import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Credits & Thanks',
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: appEdgeInsets,
            width: double.infinity,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset('assets/credits/angela.png'),
                    title: Text('Angela Yu - The App Brewery '),
                    subtitle: Text(
                        'For free flutter course and beautiful learning guidance'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('COURSE LINK'),
                        onPressed: () {
                          _launchInBrowser(
                              'https://www.appbrewery.co/p/intro-to-flutter');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: appEdgeInsets,
            width: double.infinity,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset('assets/credits/icon8.png'),
                    title: Text('Icon8'),
                    subtitle: Text('For free images for App'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('WEBSITE LINK'),
                        onPressed: () {
                          _launchInBrowser('https://icons8.com/');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
