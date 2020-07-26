import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/add.dart';

import '../contants.dart';

class ProductListItemWidget extends StatefulWidget {
  final Product product;
  final Function actionCallback;

  ProductListItemWidget({this.product, this.actionCallback});

  @override
  _ProductListItemWidgetState createState() => _ProductListItemWidgetState();
}

class _ProductListItemWidgetState extends State<ProductListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: appEdgeInsets,
        child: Container(
          padding: appEdgeInsets,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xFFE4E5E9),
          ),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          widget.product.name,
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.product.company,
                          style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.product.purchaseDate),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.product.warrantyEndDate),
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
                          widget.product
                              .deleteProduct(int.parse(result[1], radix: 10));
                          widget.actionCallback(true);
                          Toast.show("Product Deleted Successfully!", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else if (result[0] == 'edit') {
                          print(widget.product.name);
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AddItem(
                                        product: widget.product,
                                        isUpdate: true,
                                      )))
                              .then((value) => setState(() => {}));
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<List<String>>>[
                        PopupMenuItem<List<String>>(
                          value: ['edit', widget.product.id.toString()],
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['delete', widget.product.id.toString()],
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
