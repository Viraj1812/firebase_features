import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();
  static AnalyticsService instance = AnalyticsService._();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    try {
      analytics = FirebaseAnalytics.instance;

      analytics
        ..setAnalyticsCollectionEnabled(true)
        ..logAppOpen()
        ..logScreenView();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logCustomEvent(
      String eventName, Map<String, dynamic>? parameters) async {
    try {
      await analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logSignInEvent(String method) async {
    try {
      await analytics.logEvent(name: method);
    } catch (e) {
      debugPrint('login : $e');
    }
  }
}
