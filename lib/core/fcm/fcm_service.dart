import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Notification permission: ${settings.authorizationStatus}");
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint("FCM TOKEN: $token");
    return token;
  }

  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(" Foreground Message Received");
      debugPrint("   title: ${message.notification?.title}");
      debugPrint("   body : ${message.notification?.body}");
      debugPrint("   data : ${message.data}");
    });
  }

  void listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint("FCM TOKEN REFRESHED: $newToken");
      // TODO: kirim token baru ke backend
    });
  }
}
