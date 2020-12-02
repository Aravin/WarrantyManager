import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
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
            RaisedButton.icon(
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
          ],
        ),
      ),
      bottomNavigationBar: BulkActionScreen(currentIndex: 2),
    );
  }
}
