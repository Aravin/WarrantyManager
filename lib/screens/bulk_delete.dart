import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/ads.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/widgets/bulk_actions.dart';

class BulkDeleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bulk Delete',
        ),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: Column(
          children: [
            'Bulk Export'.text.xl2.bold.makeCentered(),
            const HeightBox(20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete All Data'),
              onPressed: () async {
                final Product product = Product();
                product
                    .deleteProducts()
                    .then((value) => context.showToast(
                        msg: 'All Products Deleted Successfully'))
                    .catchError((onError) =>
                        context.showToast(msg: onError.toString()));
              },
            ),
            const HeightBox(20),
            'Note: This action will delete all the products/items you have saved in this application. Please backup your products/items using the Export option before deletion.'
                .text
                .bold
                .makeCentered(),
            const AdBannerWidget(),
          ],
        ),
      ),
      bottomNavigationBar: const BulkActionScreen(currentIndex: 2),
    );
  }
}
