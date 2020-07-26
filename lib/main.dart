import 'package:flutter/material.dart';
import 'package:warranty_manager/contants.dart';
import 'package:warranty_manager/screens/home.dart';

import 'package:flutter/widgets.dart';

void main() async {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryCOlor,
        accentColor: secondaryCOlor,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
