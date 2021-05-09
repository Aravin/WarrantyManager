import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/shared/string_functions.dart';
import 'package:warranty_manager/screens/image_viewer.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();

  final Product product;
  final Function actionCallback;

  ProductDetailsScreen({this.product, this.actionCallback});
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Product Details',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.keyboard_backspace),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: widget.product.productImagePath != null
                      ? Container(
                          padding: appPaddingSmall,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(7.5)),
                          child: Image.file(
                            File(widget.product.productImagePath),
                            width: 100,
                            height: 100,
                          ),
                        )
                      : Container(
                          padding: appPaddingSmall,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(7.5)),
                          child: Image.asset('assets/noimage.jpg'),
                        ),
                ),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      SizedBox(height: 7.5),
                      Text(
                        widget.product.company,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Table(
              children: [
                TableRow(
                  children: [
                    Text('Purchase Date'),
                    Text(
                      '${widget.product.purchaseDate.day}-${widget.product.purchaseDate.month}-${widget.product.purchaseDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Warranty Period'),
                    Text(
                      widget.product.warrantyPeriod,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Warranty End Date'),
                    Text(
                      '${widget.product.warrantyEndDate.day}-${widget.product.warrantyEndDate.month}-${widget.product.warrantyEndDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Category'),
                    Text(
                      widget.product.category,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Amount'),
                    Text(
                      widget.product.price.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Purchased At'),
                    Text(
                      emptyStringPlaceholder(widget.product.purchasedAt, '-'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Contact Person Name'),
                    Text(
                      emptyStringPlaceholder(widget.product.salesPerson, '-'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Support Phone Number'),
                    Text(
                      emptyStringPlaceholder(widget.product.phone, '-'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Support Email'),
                    Text(
                      emptyStringPlaceholder(widget.product.email, '-'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Quick Note'),
                    Text(
                      emptyStringPlaceholder(widget.product.notes, '-'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 175.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  widget.product.productImagePath != null
                      ? Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Product Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.productImagePath),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.productImagePath,
                                      imageName: 'Product Image',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: 20),
                  widget.product.purchaseCopyPath != null
                      ? Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Purchase Bill',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.purchaseCopyPath),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.purchaseCopyPath,
                                      imageName: 'Purchase Bill',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: 20),
                  widget.product.warrantyCopyPath != null
                      ? Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Warranty Copy',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.warrantyCopyPath),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.warrantyCopyPath,
                                      imageName: 'Warranty Copy',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: 20),
                  widget.product.additionalImagePath != null
                      ? Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Additional Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.additionalImagePath),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.additionalImagePath,
                                      imageName: 'Additional Image',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
