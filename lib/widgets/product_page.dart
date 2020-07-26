import 'package:flutter/material.dart';
import 'package:warranty_manager/contants.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/widgets/product_list.dart';

class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
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
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
              child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                indicatorColor: secondaryCOlor,
                labelColor: primaryColor,
                tabs: <Widget>[
                  Tab(text: 'ACTIVE'),
                  Tab(text: 'EXPIRING'),
                  Tab(text: 'EXPIRED'),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  FutureBuilder<List<Product>>(
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                          ),
                        );

                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((product) => ProductListItemWidget(
                                  product: product,
                                  actionCallback: actionCallback))
                              .where((element) => DateTime.parse(element
                                      .product.warrantyEndDate
                                      .toString())
                                  .isAfter(DateTime.now()))
                              .toList());
                    },
                  ),
                  FutureBuilder<List<Product>>(
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                          ),
                        );

                      var tempDate = new DateTime.now();

                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((product) => ProductListItemWidget(
                                  product: product,
                                  actionCallback: actionCallback))
                              .where((element) => DateTime.parse(element
                                      .product.warrantyEndDate
                                      .toString())
                                  .isAfter(DateTime.now()))
                              .where(
                                (element) => DateTime.parse(element
                                        .product.warrantyEndDate
                                        .toString())
                                    .isBefore(new DateTime(tempDate.year,
                                        tempDate.month + 1, tempDate.day)),
                              )
                              .toList());
                    },
                  ),
                  FutureBuilder<List<Product>>(
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800)),
                          ),
                        );

                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((product) => ProductListItemWidget(
                                  product: product,
                                  actionCallback: actionCallback))
                              .where((element) => DateTime.parse(element
                                      .product.warrantyEndDate
                                      .toString())
                                  .isBefore(DateTime.now()))
                              .toList());
                    },
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
