import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/image_viewer.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/shared/string_functions.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();

  final Product product;
  final Function? actionCallback;

  const ProductDetailsScreen({super.key, required this.product, this.actionCallback});
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_backspace),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            File(widget.product.productImagePath!),
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
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      const SizedBox(height: 7.5),
                      Text(
                        widget.product.company,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Table(
              children: [
                TableRow(
                  children: [
                    const Text('Purchase Date'),
                    Text(
                      '${widget.product.purchaseDate!.day}-${widget.product.purchaseDate!.month}-${widget.product.purchaseDate!.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Warranty Period'),
                    Text(
                      widget.product.warrantyPeriod,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Warranty End Date'),
                    Text(
                      '${widget.product.warrantyEndDate!.day}-${widget.product.warrantyEndDate!.month}-${widget.product.warrantyEndDate!.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Category'),
                    Text(
                      widget.product.category,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Amount'),
                    Text(
                      widget.product.price.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Purchased At'),
                    Text(
                      emptyStringPlaceholder(widget.product.purchasedAt, '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Contact Person Name'),
                    Text(
                      emptyStringPlaceholder(widget.product.salesPerson, '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Support Phone Number'),
                    Text(
                      emptyStringPlaceholder(widget.product.phone, '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Support Email'),
                    Text(
                      emptyStringPlaceholder(widget.product.email, '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text('Quick Note'),
                    Text(
                      emptyStringPlaceholder(widget.product.notes, '-'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              height: 175.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (widget.product.productImagePath != null) Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Product Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.productImagePath!),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.productImagePath!,
                                      imageName: 'Product Image',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) else const SizedBox(),
                  const SizedBox(width: 20),
                  if (widget.product.purchaseCopyPath != null) Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Purchase Bill',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.purchaseCopyPath!),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.purchaseCopyPath!,
                                      imageName: 'Purchase Bill',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) else const SizedBox(),
                  const SizedBox(width: 20),
                  if (widget.product.warrantyCopyPath != null) Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Warranty Copy',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.warrantyCopyPath!),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.warrantyCopyPath!,
                                      imageName: 'Warranty Copy',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) else const SizedBox(),
                  const SizedBox(width: 20),
                  if (widget.product.additionalImagePath != null) Container(
                          width: 165.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Additional Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Image.file(
                                  File(widget.product.additionalImagePath!),
                                  width: 150,
                                  height: 150,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctxt) => DisplayImage(
                                      imagePath:
                                          widget.product.additionalImagePath!,
                                      imageName: 'Additional Image',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) else const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
