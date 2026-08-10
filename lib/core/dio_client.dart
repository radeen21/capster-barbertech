import 'package:capster_barbertech/core/env/env_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("session_token");

          debugPrint("➡️ ${options.method} ${options.path}");
          debugPrint("➡️ TOKEN = $token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            debugPrint("❌ 401 DETECTED");

            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString("refresh_token");

            debugPrint("🔄 REFRESH TOKEN = $refreshToken");

            if (refreshToken == null || refreshToken.isEmpty) {
              debugPrint("❌ NO REFRESH TOKEN");
              return handler.next(error);
            }

            try {
              final refreshDio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

              final refreshResponse = await refreshDio.post(
                "/auth/refresh",
                data: {"refresh_token": refreshToken},
              );

              final data = refreshResponse.data["data"];

              await prefs.setString("session_token", data["session_token"]);
              await prefs.setString("refresh_token", data["refresh_token"]);

              debugPrint("✅ TOKEN REFRESH SUCCESS");

              error.requestOptions.headers["Authorization"] =
                  "Bearer ${data["session_token"]}";

              final retryResponse = await dio.fetch(error.requestOptions);

              return handler.resolve(retryResponse);
            } catch (e) {
              debugPrint("❌ REFRESH FAILED: $e");
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Dio createWithoutAuth() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer public", // ✅ WAJIB ADA
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("🟡 PUBLIC REQUEST HEADERS:");
          debugPrint(options.headers.toString());
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    debugPrint("🚫 DIO WITHOUT AUTH INITIALIZED");

    return dio;
  }
}
