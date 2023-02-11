import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static Future<String?> initializeMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    Future<String?> registrationToken = messaging.getToken();

    return registrationToken;
  }
}
