import 'package:firebase_features/ui/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initilize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(id: payload ?? 'default'),
        ),
      );
    });
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    const notificationDetail = NotificationDetails(
        android: AndroidNotificationDetails(
            "firebase_feature", "firebase_push_notification",
            importance: Importance.max, priority: Priority.high));

    _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetail,
        payload: message.data["message"]);
  }
}
