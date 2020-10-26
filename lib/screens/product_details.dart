import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/string_functions.dart';
import 'package:warranty_manager/screens/image_viewer.dart';

import '../shared/contants.dart';

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
      body: Padding(
        padding: appEdgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: widget.product.productImage != null
                      ? Image.memory(
                          widget.product.productImage,
                          width: 100,
                          height: 100,
                        )
                      : Image.asset('assets/noimage.jpg'),
                ),
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
                      Text(
                        widget.product.company,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                    Text('Warrant End Date'),
                    Text(
                      '${widget.product.warrantyEndDate.day}-${widget.product.warrantyEndDate.month}-${widget.product.warrantyEndDate.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Cateogory'),
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
                    Text('support Email'),
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
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 175.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  widget.product.productImage != null
                      ? Container(
                          width: 150.0,
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Text('Product Image'),
                              GestureDetector(
                                child: Image.memory(
                                  widget.product.productImage,
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imageBlob: widget.product.productImage,
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
                  widget.product.purchaseCopy != null
                      ? Container(
                          width: 150.0,
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Text('Purchase Bill'),
                              GestureDetector(
                                child: Image.memory(
                                  widget.product.purchaseCopy,
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imageBlob: widget.product.purchaseCopy,
                                      imageName: 'Purchase Bill',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  widget.product.warrantyCopy != null
                      ? Container(
                          width: 150.0,
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Text('Warranty Copy'),
                              GestureDetector(
                                child: Image.memory(
                                  widget.product.warrantyCopy,
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imageBlob: widget.product.warrantyCopy,
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
                  widget.product.additionalImage != null
                      ? Container(
                          width: 150.0,
                          color: Colors.black12,
                          child: Column(
                            children: [
                              Text('Additional Image'),
                              GestureDetector(
                                child: Image.memory(
                                  widget.product.additionalImage,
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imageBlob: widget.product.additionalImage,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    color: secondaryCOlor,
                    textColor: Colors.white,
                    child: Text("Go Back"),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
