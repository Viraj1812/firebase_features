import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHelper {
  final fcm = FirebaseMessaging.instance;

  void setupPushNotification() async {
    await fcm.requestPermission();
    await fcm.getToken();
    fcm.subscribeToTopic('chat');
  }
}
