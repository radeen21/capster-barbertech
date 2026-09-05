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

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {

            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString("refresh_token");

            if (refreshToken == null || refreshToken.isEmpty) {
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

              error.requestOptions.headers["Authorization"] =
                  "Bearer ${data["session_token"]}";

              final retryResponse = await dio.fetch(error.requestOptions);

              return handler.resolve(retryResponse);
            } catch (e) {
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
          "Authorization": "Bearer public", 
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
