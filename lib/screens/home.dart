import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/about.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:warranty_manager/screens/bulk_upload.dart';
import 'package:warranty_manager/screens/privacy_policy.dart';
import 'package:warranty_manager/screens/product_list.dart';
import 'package:warranty_manager/widgets/product_highlight.dart';
import 'package:warranty_manager/widgets/product_page.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final product = new Product();

  actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    actionCallback(true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Warranty Manager',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddItem(
                                  isUpdate: false,
                                )))
                        .then((value) => setState(() => {}))
                  }).circle(radius: 40, backgroundColor: secondaryColor),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
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
            // ListTile(
            //   title: Text('Bulk Actions'),
            //   leading: Icon(Icons.group_work),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (ctxt) => BulkUploadScreen()),
            //     );
            //   },
            // ),
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
              onTap: () async {
                Navigator.pop(context);
                final InAppReview inAppReview = InAppReview.instance;

                inAppReview.openStoreListing();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
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
