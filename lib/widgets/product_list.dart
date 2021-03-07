import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:warranty_manager/screens/product_details.dart';

import '../shared/contants.dart';

class ProductListItemWidget extends StatelessWidget {
  final Product product;
  final Function actionCallback;
  final Color cardColor;

  ProductListItemWidget({this.product, this.actionCallback, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: appPaddingSmall,
        child: Container(
          padding: appEdgeInsets,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: cardColor ?? Color(0xFFE4E5E9),
          ),
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.company,
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Purchase Date',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Valid Till',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(product.purchaseDate),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(product.warrantyEndDate),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<List<String>>(
                      onSelected: (List<String> result) {
                        if (result[0] == 'delete') {
                          product
                              .deleteProduct(int.parse(result[1], radix: 10));
                          actionCallback(true);
                          Toast.show("Product Deleted Successfully!", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else if (result[0] == 'edit') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddItem(
                                product: product,
                                isUpdate: true,
                                actionCallback: this.actionCallback,
                              ),
                            ),
                          );
                        } else if (result[0] == 'view') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: product,
                                actionCallback: this.actionCallback,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<List<String>>>[
                        PopupMenuItem<List<String>>(
                          value: ['view', product.id.toString()],
                          child: Text('View'),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['edit', product.id.toString()],
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['delete', product.id.toString()],
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
