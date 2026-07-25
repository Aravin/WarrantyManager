import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:warranty_manager/screens/product_details.dart';

import 'package:warranty_manager/shared/contants.dart';

class ProductListItemWidget extends StatelessWidget {
  final Product product;
  final Function actionCallback;
  final Color? cardColor;

  const ProductListItemWidget({super.key, required this.product, required this.actionCallback, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: appPaddingSmall,
        child: Container(
          padding: appEdgeInsets,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: cardColor ?? const Color(0xFFE4E5E9),
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
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          product.company,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(product.purchaseDate!),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(product.warrantyEndDate!),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<List<String>>(
                      onSelected: (List<String> result) {
                        if (result[0] == 'delete') {
                          product
                              .deleteProduct(int.parse(result[1], radix: 10));
                          actionCallback(true);
                          Toast.show("Product Deleted Successfully!",
                              duration: Toast.lengthLong);
                        } else if (result[0] == 'edit') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddItem(
                                product: product,
                                isUpdate: true,
                                actionCallback: actionCallback,
                              ),
                            ),
                          );
                        } else if (result[0] == 'view') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: product,
                                actionCallback: actionCallback,
                              ),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<List<String>>>[
                        PopupMenuItem<List<String>>(
                          value: ['view', product.id.toString()],
                          child: const Text('View'),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['edit', product.id.toString()],
                          child: const Text('Edit'),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['delete', product.id.toString()],
                          child: const Text('Delete'),
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
