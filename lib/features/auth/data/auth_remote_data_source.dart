import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final fcmToken = await _getFcmToken();
      final deviceInfo = await _getDeviceInfo();

      final body = {
        "identifier": email,
        "password": password,
        "fcm_token": fcmToken,
        "device_info": deviceInfo,
      };

      print("LOGIN REQUEST BODY = $body");

      const path = "/auth/login";

      final response = await dio.post(
        path,
        data: body,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await dio.post(
      "/auth/refresh",
      data: {"refresh_token": refreshToken},
    );
    return response.data["data"];
  }

  @override
  Future<void> logout() async {
    await dio.post("/auth/logout");
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;

      return {
        "os": "Android",
        "model": android.model, // contoh: Pixel 7
        "version": android.version.release, // contoh: 14
      };
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;

      return {
        "os": "iOS",
        "model": ios.utsname.machine,
        "version": ios.systemVersion,
      };
    }

    return {"os": "Unknown", "model": "Unknown", "version": "Unknown"};
  }

  Future<String?> _getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return null;
    }
  }
}
