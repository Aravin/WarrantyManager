import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Items',
        ),
      ),
      body: Padding(
        padding: appEdgeInsets,
        child: Column(
          children: <Widget>[
            Container(
              child: const Text(
                'Warranty Manager',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: const Text(
                'This is Free to use Application. You can store the warranty information of any of your product / service. All your information are stored in your device locally.',
              ),
            )
          ],
        ),
      ),
    );
  }
}
