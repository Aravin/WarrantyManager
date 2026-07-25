import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:warranty_manager/init.dart';
import 'package:warranty_manager/screens/home.dart';
import 'package:warranty_manager/shared/contants.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(Main());
  }, (error, stackTrace) {
    debugPrint('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class Main extends StatelessWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, secondary: secondaryColor),
      ),
      home: FutureBuilder(
        future: AppInitialization.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong! ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }

          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
