import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_features/firebase_options.dart';
import 'package:firebase_features/ui/splash_scrren.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    ),
  );
}
