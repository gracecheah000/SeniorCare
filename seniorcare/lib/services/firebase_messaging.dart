import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seniorcare/services/notification_api.dart';

class FirebaseMessagingService {
  static Future<String?> initializeMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    Future<String?> registrationToken = messaging.getToken();

    NotificationServices.init(initScheduled: true);

    return registrationToken;
  }
}
