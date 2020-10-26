import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Privacy Policy',
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebviewScaffold(
          url: 'https://www.epix.io/terms-policy',
          withJavascript: false,
          withZoom: false,
          hidden: true,
        );
      }),
    );
  }
}
