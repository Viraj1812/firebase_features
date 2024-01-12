import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_features/firebase_options.dart';
import 'package:firebase_features/services/firebase_analytics_service.dart';
import 'package:firebase_features/services/firebase_cloud_messaging.dart';
import 'package:firebase_features/ui/splash_scrren.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
      FCMHelper().firebaseMessagingBackgroundHandler);
  await AnalyticsService.instance.init();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    ),
  );
}
