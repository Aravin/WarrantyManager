import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/about.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:warranty_manager/screens/credits.dart';
import 'package:warranty_manager/screens/privacy_policy.dart';
import 'package:warranty_manager/screens/product_list.dart';
import 'package:warranty_manager/widgets/product_highlight.dart';
import 'package:warranty_manager/widgets/product_page.dart';

import '../contants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final product = new Product();

  Future<List<Product>> _products() async {
    return product.getProducts();
  }

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

  actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Warranty Manager',
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
            ),
            ListTile(
              title: Text('Saved Items'),
              leading: Icon(Icons.security),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctxt) => ProductListScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.description),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctxt) => PrivacyPolicyScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Credits'),
              leading: Icon(Icons.thumb_up),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctxt) => CreditsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctxt) => AboutScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Rate Us'),
              leading: Icon(Icons.thumbs_up_down),
              onTap: () {
                Navigator.pop(context);
                _launchInBrowser(
                    'https://play.google.com/store/apps/details?id=io.epix.warranty_manager');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AddItem(
                        isUpdate: false,
                      )))
              .then((value) => setState(() => {}));
        },
        child: Icon(Icons.add),
        backgroundColor: secondaryCOlor,
      ),
      body: Column(
        children: <Widget>[
          // Padding(
          //   padding: appEdgeInsets,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       Expanded(
          //         flex: 10,
          //         child: RichText(
          //           text: TextSpan(
          //             children: <TextSpan>[
          //               TextSpan(
          //                   text: 'Hello,',
          //                   style: TextStyle(
          //                       fontSize: 30.0,
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.grey[500])),
          //               TextSpan(
          //                   text: ' User!',
          //                   style: TextStyle(
          //                     fontSize: 35.0,
          //                     fontWeight: FontWeight.w900,
          //                     color: Colors.grey[700],
          //                   )),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         flex: 2,
          //         child: Text('Hi'),
          //       ),
          //     ],
          //   ),
          // ),
          ProductHighlightWidget(actionCallback: actionCallback),
          SizedBox(
            height: 7.0,
          ),
          ProductListWidget(actionCallback: actionCallback),
        ],
      ),
    );
  }
}
