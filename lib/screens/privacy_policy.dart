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
      persistentFooterButtons: [SizedBox(height: 35)],
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
