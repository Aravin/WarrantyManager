import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/widgets/product_list.dart';

class ProductListWidget extends StatelessWidget {
  final product = Product();
  late final Function actionCallback;
  final tempDate = DateTime.now();

  ProductListWidget({super.key, required this.actionCallback});

  Future<List<Product>> _products() async {
    return product.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TabBar(
                indicatorColor: secondaryColor,
                labelColor: primaryColor,
                tabs: <Widget>[
                  Tab(
                    child: FutureBuilder<List<Product>>(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('ACTIVE (${snapshot.data!
                                    .where((element) =>
                                        element.warrantyEndDate != null &&
                                        element.warrantyEndDate!
                                            .isAfter(DateTime.now()))
                                    .toList()
                                    .length})');
                          }
                          return const Text('ACTIVE (0)');
                        }),
                  ),
                  Tab(
                    child: FutureBuilder<List<Product>>(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('EXPIRING (${snapshot.data!
                                    .where((element) =>
                                        element.warrantyEndDate != null &&
                                        element.warrantyEndDate!
                                            .isAfter(DateTime.now()))
                                    .where(
                                      (element) => element.warrantyEndDate!
                                          .isBefore(
                                        DateTime(tempDate.year,
                                            tempDate.month + 1, tempDate.day),
                                      ),
                                    )
                                    .toList()
                                    .length})');
                          }
                          return const Text('EXPIRING (0)');
                        }),
                  ),
                  Tab(
                    child: FutureBuilder<List<Product>>(
                        future: _products(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('EXPIRED (${snapshot.data!
                                    .where((element) =>
                                        element.warrantyEndDate != null &&
                                        element.warrantyEndDate!
                                            .isBefore(DateTime.now()))
                                    .toList()
                                    .length})');
                          }
                          return const Text('EXPIRED (0)');
                        }),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }

                        final activeProducts = snapshot.data!
                            .where((element) =>
                                element.warrantyEndDate != null &&
                                element.warrantyEndDate!
                                    .isAfter(DateTime.now()))
                            .toList();

                        if (activeProducts.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
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
                          shrinkWrap: true,
                          children: activeProducts
                              .map((product) => ProductListItemWidget(
                                    product: product,
                                    actionCallback: actionCallback,
                                    cardColor: Colors.green[100],
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }

                        final expiringProducts = snapshot.data!
                            .where((element) =>
                                element.warrantyEndDate != null &&
                                element.warrantyEndDate!
                                    .isAfter(DateTime.now()))
                            .where(
                              (element) => element.warrantyEndDate!.isBefore(
                                DateTime(tempDate.year,
                                    tempDate.month + 1, tempDate.day),
                              ),
                            )
                            .toList();

                        if (expiringProducts.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
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
                          shrinkWrap: true,
                          children: expiringProducts
                              .map((product) => ProductListItemWidget(
                                    product: product,
                                    actionCallback: actionCallback,
                                    cardColor: Colors.orange[100],
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<Product>>(
                    future: _products(),
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Error Occurred ${snapshot.error}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (!snapshot.hasError && snapshot.data!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'No Product Saved, Click on + button to save the product details!',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                        }

                        final expiredProducts = snapshot.data!
                            .where((element) =>
                                element.warrantyEndDate != null &&
                                element.warrantyEndDate!
                                    .isBefore(DateTime.now()))
                            .toList();

                        if (expiredProducts.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
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

                        return ListView(
                          shrinkWrap: true,
                          children: expiredProducts
                              .map((product) => ProductListItemWidget(
                                    product: product,
                                    actionCallback: actionCallback,
                                    cardColor: Colors.red[100],
                                  ))
                              .toList(),
                        );
                      }
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
