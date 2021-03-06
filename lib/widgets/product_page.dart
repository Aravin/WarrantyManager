import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/ads.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/widgets/product_list.dart';

class ProductListWidget extends StatelessWidget {
  final product = new Product();
  final Function actionCallback;
  final tempDate = new DateTime.now();

  ProductListWidget({this.actionCallback});

  Future<List<Product>> _products() async {
    return product.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AdmobBanner(
          //   adUnitId: AdManager.bannerAdUnitId,
          //   adSize: AdmobBannerSize.BANNER,
          //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          //     print([event, args, 'Banner']);
          //   },
          //   onBannerCreated: (AdmobBannerController controller) {
          //     // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
          //     // Normally you don't need to worry about disposing this yourself, it's handled.
          //     // If you need direct access to dispose, this is your guy!
          //     // controller.dispose();
          //   },
          // ),
          Expanded(
              child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                indicatorColor: secondaryColor,
                labelColor: primaryColor,
                tabs: <Widget>[
                  Tab(
                    child: FutureBuilder(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('ACTIVE (' +
                                snapshot.data
                                    .map((product) => product)
                                    .where((element) => DateTime.parse(
                                            element.warrantyEndDate.toString())
                                        .isAfter(DateTime.now()))
                                    .where(
                                      (element) => DateTime.parse(element
                                              .warrantyEndDate
                                              .toString())
                                          .isAfter(DateTime.now()),
                                    )
                                    .toList()
                                    .length
                                    .toString() +
                                ')');
                          }
                          return Text('ACTIVE (0)');
                        }),
                  ),
                  Tab(
                    child: FutureBuilder(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('EXPIRING (' +
                                snapshot.data
                                    .map((product) => product)
                                    .where((element) => DateTime.parse(
                                            element.warrantyEndDate.toString())
                                        .isAfter(DateTime.now()))
                                    .where(
                                      (element) => DateTime.parse(element
                                              .warrantyEndDate
                                              .toString())
                                          .isBefore(
                                        new DateTime(tempDate.year,
                                            tempDate.month + 1, tempDate.day),
                                      ),
                                    )
                                    .toList()
                                    .length
                                    .toString() +
                                ')');
                          }
                          return Text('EXPIRING (0)');
                        }),
                  ),
                  Tab(
                    child: FutureBuilder(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('EXPIRED (' +
                                snapshot.data
                                    .map((product) => product)
                                    .where(
                                      (element) => DateTime.parse(element
                                              .warrantyEndDate
                                              .toString())
                                          .isBefore(DateTime.now()),
                                    )
                                    .toList()
                                    .length
                                    .toString() +
                                ')');
                          }
                          return Text('EXPIRED (0)');
                        }),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError)
                        return Center(child: CircularProgressIndicator());

                      if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ' + snapshot.error.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data.length == 0)
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );

                        if (snapshot.data
                                .map((product) => product)
                                .where((element) => DateTime.parse(
                                        element.warrantyEndDate.toString())
                                    .isAfter(DateTime.now()))
                                .where(
                                  (element) => DateTime.parse(
                                          element.warrantyEndDate.toString())
                                      .isAfter(DateTime.now()),
                                )
                                .toList()
                                .length ==
                            0) {
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Active Product!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((product) => ProductListItemWidget(
                                    product: product,
                                    actionCallback: actionCallback,
                                    cardColor: Colors.green[100],
                                  ))
                              .where(
                                (element) => DateTime.parse(element
                                        .product.warrantyEndDate
                                        .toString())
                                    .isAfter(DateTime.now()),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError)
                        return Center(child: CircularProgressIndicator());

                      if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ' + snapshot.error.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data.length == 0)
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );

                        if (snapshot.data
                                .map((product) => product)
                                .where((element) => DateTime.parse(
                                        element.warrantyEndDate.toString())
                                    .isAfter(DateTime.now()))
                                .where(
                                  (element) => DateTime.parse(
                                          element.warrantyEndDate.toString())
                                      .isBefore(
                                    new DateTime(tempDate.year,
                                        tempDate.month + 1, tempDate.day),
                                  ),
                                )
                                .toList()
                                .length ==
                            0) {
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Expiring in 30 days!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((product) => ProductListItemWidget(
                                    product: product,
                                    actionCallback: actionCallback,
                                    cardColor: Colors.orange[100],
                                  ))
                              .where((element) => DateTime.parse(element
                                      .product.warrantyEndDate
                                      .toString())
                                  .isAfter(DateTime.now()))
                              .where(
                                (element) => DateTime.parse(element
                                        .product.warrantyEndDate
                                        .toString())
                                    .isBefore(
                                  new DateTime(tempDate.year,
                                      tempDate.month + 1, tempDate.day),
                                ),
                              )
                              .toList(),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError)
                        return Center(child: CircularProgressIndicator());

                      if (snapshot.hasError) {
                        return Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ' + snapshot.error.toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (!snapshot.hasError && snapshot.data.length == 0)
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );

                        if (!snapshot.hasError &&
                            snapshot.data
                                    .map((product) => product)
                                    .where(
                                      (element) => DateTime.parse(element
                                              .warrantyEndDate
                                              .toString())
                                          .isBefore(DateTime.now()),
                                    )
                                    .toList()
                                    .length ==
                                0) {
                          return Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No Products Expired!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data
                            .map((product) => ProductListItemWidget(
                                  product: product,
                                  actionCallback: actionCallback,
                                  cardColor: Colors.red[100],
                                ))
                            .where(
                              (element) => DateTime.parse(element
                                      .product.warrantyEndDate
                                      .toString())
                                  .isBefore(DateTime.now()),
                            )
                            .toList(),
                      );
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
