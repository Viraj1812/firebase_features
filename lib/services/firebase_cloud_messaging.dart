import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMHelper {
  final fcm = FirebaseMessaging.instance;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setupPushNotification() async {
    await fcm.requestPermission();
    await fcm.getToken();
    fcm.subscribeToTopic('chat');
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('A bg message just showed up : ${message.messageId} ');
    debugPrint('A bg message just showed up : ${message.notification?.title} ');
    debugPrint('A bg message just showed up : ${message.notification?.body} ');
  }
}
