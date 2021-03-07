import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/ads.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/widgets/bulk_actions.dart';

class BulkDeleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Bulk Delete',
        ),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            'Bulk Export'.text.xl2.bold.makeCentered(),
            HeightBox(20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
              ),
              icon: Icon(Icons.delete_forever),
              label: Text('Delete All Data'),
              onPressed: () async {
                Product product = new Product();
                product
                    .deleteProducts()
                    .then((value) => context.showToast(
                        msg: 'All Products Deleted Successfully'))
                    .catchError((onError) =>
                        context.showToast(msg: onError.toString()));
              },
            ),
            HeightBox(20),
            'Note: This action will delete all the products/items you have saved in this application. Please backup your products/items using the Export option before deletion.'
                .text
                .bold
                .makeCentered(),
            AdmobBanner(
              adUnitId: AdManager.bannerAdUnitId,
              adSize: AdmobBannerSize.LARGE_BANNER,
              listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                print([event, args, 'Banner']);
              },
              onBannerCreated: (AdmobBannerController controller) {
                // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                // Normally you don't need to worry about disposing this yourself, it's handled.
                // If you need direct access to dispose, this is your guy!
                // controller.dispose();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BulkActionScreen(currentIndex: 2),
    );
  }
}
