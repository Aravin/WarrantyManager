import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/screens/home.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  runApp(Main());
}

class Main extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        // primarySwatch: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        accentColor: secondaryColor,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
