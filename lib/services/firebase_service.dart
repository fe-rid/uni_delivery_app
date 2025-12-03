import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Service class for Firebase services initialization
/// Note: Firebase.initializeApp() must be called before this
class FirebaseService {
  static Future<void> initialize() async {
    try {
      // Request notification permissions
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('User granted notification permission');
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          debugPrint('User granted provisional notification permission');
        } else {
          debugPrint(
              'User declined or has not accepted notification permission');
        }

        // Get FCM token
        String? token = await messaging.getToken();
        debugPrint('FCM Token: $token');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase services initialization error: $e');
      }
      // Don't rethrow - messaging is optional
    }
  }
}
