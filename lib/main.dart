import 'dart:async';

import 'package:flutter/material.dart';
import 'package:warranty_manager/init.dart';
import 'package:warranty_manager/initilization/firebase.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/screens/home.dart';

import 'package:flutter/widgets.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   bool inDebug = false;
  //   assert(() {
  //     inDebug = true;
  //     return true;
  //   }());
  //   // In debug mode, use the normal error widget which shows
  //   // the error message:
  //   if (inDebug) return ErrorWidget(details.exception);
  //   // In release builds, show a yellow-on-blue message instead:
  //   return Container(
  //     alignment: Alignment.center,
  //     child: Text(
  //       'Error!',
  //       style: TextStyle(color: Colors.yellow),
  //       textDirection: TextDirection.ltr,
  //     ),
  //   );
  // };

  WidgetsFlutterBinding.ensureInitialized();
  // Pass all uncaught errors from the framework to Crashlytics.
  runZonedGuarded(() {
    runApp(Main());
  }, (error, stackTrace) {
    debugPrint('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  // runApp(ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        accentColor: secondaryColor,
        textTheme: Typography.blackCupertino,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: AppInitialization.Init(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong! ${snapshot.error}'));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
