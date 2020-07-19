import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/add.dart';

import '../contants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final product = new Product();

  Future<List<Product>> _products() async {
    return product.getProducts();
  }

  actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AddItem(
                        isUpdate: false,
                      )))
              .then((value) => setState(() => {}));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFC3259),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: appEdgeInsets,
              child: RichText(
                text: TextSpan(
                  // style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Hello,',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500])),
                    TextSpan(
                        text: ' User!',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[700],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              margin: appEdgeInsets,
              height: 100.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFC3259),
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: Icon(
                              Icons.security,
                              color: Colors.white60,
                            )),
                            Expanded(
                                child: Text(
                              'In Warranty',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            )),
                            Expanded(
                              child: FutureBuilder(
                                  future: _products(),
                                  initialData: List(),
                                  builder: (context, snapshot) {
                                    var inWarranty = 0;
                                    if (snapshot.hasData) {
                                      for (var i = 0;
                                          i < snapshot.data.length;
                                          i++) {
                                        if (DateTime.parse(snapshot
                                                .data[i].warrantyEndDate
                                                .toString())
                                            .isAfter(DateTime.now())) {
                                          inWarranty++;
                                        }
                                      }
                                    }
                                    return Text(
                                      inWarranty.toString(),
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 25.0,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF6E4BD9),
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: Icon(
                              Icons.timer_off,
                              color: Colors.white60,
                            )),
                            Expanded(
                                child: Text(
                              'Out-of Warranty',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            )),
                            Expanded(
                              child: FutureBuilder(
                                  future: _products(),
                                  initialData: List(),
                                  builder: (context, snapshot) {
                                    var inWarranty = 0;
                                    if (snapshot.hasData) {
                                      for (var i = 0;
                                          i < snapshot.data.length;
                                          i++) {
                                        if (DateTime.parse(snapshot
                                                .data[i].warrantyEndDate
                                                .toString())
                                            .isBefore(DateTime.now())) {
                                          inWarranty++;
                                        }
                                      }
                                    }
                                    return Text(
                                      inWarranty.toString(),
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 25.0,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: SizedBox(
                height: 7.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(7.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'All Item',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  // Text(
                  //   'In Warranty',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                  // Text(
                  //   'Out-of Warranty',
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _products(),
                initialData: List(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  if (!snapshot.hasError && snapshot.data.length == 0)
                    return Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                            'No Product Saved, Click on + button to save the product details!',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w800)),
                      ),
                    );

                  return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data
                          .map((product) => ProductListWidget(
                              product: product, actionCallback: actionCallback))
                          .toList());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  final Product product;
  final Function actionCallback;

  ProductListWidget({this.product, this.actionCallback});

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
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
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        PopupMenuItem<List<String>>(
                          value: ['delete', widget.product.id.toString()],
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.black),
                          ),
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
