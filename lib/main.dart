import 'package:flutter/material.dart';
import 'package:warranty_manager/screens/home.dart';

import 'package:flutter/widgets.dart';

void main() async {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        // primarySwatch: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        highlightColor: Color(0xFF6E4BD9),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: Home(),
    );
  }
}
