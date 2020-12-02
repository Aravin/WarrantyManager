import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/widgets/bulk_actions.dart';

class BulkExportScreen extends StatelessWidget {
  // Write data to the file
  Future<String> _writeToFile(String data) async {
    try {
      final directory = await getExternalStorageDirectory();
      final path = directory.path;
      final fileName =
          '$path/warranty_manager_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(fileName);

      String returnMsg = 'fileName';

      // Write the file.
      await file
          .writeAsString('$data')
          .then((value) => returnMsg = 'Exported to $file')
          .catchError((onError) => returnMsg = 'Error');

      return returnMsg;
    } catch (err) {
      return err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Bulk Export',
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
              icon: Icon(Icons.save_alt),
              label: Text('Export Data'),
              onPressed: () async {
                Product product = new Product();
                String stringToWrite =
                    'name, price, purchaseDate, warrantyPeriod, company, category, purchasedAt,  salesPerson, phone, email, notes\n';

                await product.getProducts().then((value) async {
                  for (var item in value) {
                    var currItem = item.toMap();
                    stringToWrite = stringToWrite +
                        '${currItem['name']}, ${currItem['price']}, ${DateTime.parse(currItem['purchaseDate'])}, ${currItem['warrantyPeriod']}, ${currItem['company']}, ${currItem['category']}, ${currItem['purchasedAt']}, ${currItem['salesPerson']}, ${currItem['phone']}, ${currItem['email']}, ${currItem['notes']}, \n';
                  }
                });
                await _writeToFile(stringToWrite)
                    .then((value) =>
                        context.showToast(msg: value, showTime: 5000))
                    .catchError((onError) => context.showToast(
                        msg: onError.toString(), showTime: 5000));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BulkActionScreen(currentIndex: 1),
    );
  }
}
