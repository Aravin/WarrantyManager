import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/about.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:warranty_manager/screens/product_list.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/widgets/product_highlight.dart';
import 'package:warranty_manager/widgets/product_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final product = Product();

  void actionCallback(bool rebuild) {
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
        title: const Text(
          'Warranty Manager',
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => const AddItem(
                                  
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ),
            ListTile(
              title: const Text('Saved Items'),
              leading: const Icon(Icons.security),
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
              title: const Text('Pro Version'),
              leading: const Icon(Icons.star),
              onTap: () async {
                Navigator.pop(context);
                final Uri uri = Uri.parse('https://play.google.com/store/apps/details?id=net.aravin.warranty_manager_cloud&hl=en_IN');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              title: const Text('About'),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctxt) => AboutScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Rate Us'),
              leading: const Icon(Icons.thumbs_up_down),
              onTap: () async {
                Navigator.pop(context);
                final InAppReview inAppReview = InAppReview.instance;

                await inAppReview.openStoreListing();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          ProductHighlightWidget(actionCallback: actionCallback),
          const SizedBox(
            height: 7.0,
          ),
          ProductListWidget(actionCallback: actionCallback),
        ],
      ),
    );
  }
}
