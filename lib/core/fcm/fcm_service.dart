import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Request permission (Android 13+ wajib)
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("🔔 Notification permission: ${settings.authorizationStatus}");
  }

  /// Get FCM Token
  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint("🔥 FCM TOKEN: $token");
    return token;
  }

  /// Listen foreground messages
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground Message Received");
      debugPrint("   title: ${message.notification?.title}");
      debugPrint("   body : ${message.notification?.body}");
      debugPrint("   data : ${message.data}");
    });
  }

  /// Listen token refresh
  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("♻️ FCM TOKEN REFRESHED: $newToken");
      // TODO: kirim token baru ke backend
    });
  }
}
