import 'package:flutter/material.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/contants.dart';

class ProductHighlightWidget extends StatelessWidget {
  final product = Product();
  final Function actionCallback;

  ProductHighlightWidget({super.key, required this.actionCallback});

  Future<List<Product>> _products() async {
    return product.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: appEdgeInsets,
      height: 100.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(7.5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Expanded(
                        child: Icon(
                      Icons.security,
                      color: Colors.white60,
                    )),
                    const Expanded(
                        child: Text(
                      'In Warranty',
                      style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    )),
                    Expanded(
                      child: FutureBuilder<List<Product>>(
                          future: _products(),
                          initialData: const <Product>[],
                          builder: (context, snapshot) {
                            var inWarranty = 0;
                            if (snapshot.hasData) {
                              for (var i = 0; i < snapshot.data!.length; i++) {
                                if (snapshot.data![i].warrantyEndDate != null &&
                                    snapshot.data![i].warrantyEndDate!
                                        .isAfter(DateTime.now())) {
                                  inWarranty++;
                                }
                              }
                            }
                            return Text(
                              inWarranty.toString(),
                              style: const TextStyle(
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
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(7.5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Expanded(
                        child: Icon(
                      Icons.timer_off,
                      color: Colors.white60,
                    )),
                    const Expanded(
                        child: Text(
                      'Out-of Warranty',
                      style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    )),
                    Expanded(
                      child: FutureBuilder<List<Product>>(
                          future: _products(),
                          initialData: const <Product>[],
                          builder: (context, snapshot) {
                            var inWarranty = 0;
                            if (snapshot.hasData) {
                              for (var i = 0; i < snapshot.data!.length; i++) {
                                if (snapshot.data![i].warrantyEndDate != null &&
                                    snapshot.data![i].warrantyEndDate!
                                        .isBefore(DateTime.now())) {
                                  inWarranty++;
                                }
                              }
                            }
                            return Text(
                              inWarranty.toString(),
                              style: const TextStyle(
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
    );
  }
}
