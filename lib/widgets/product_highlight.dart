import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:warranty_manager/providers/productProvider.dart';

class ProductHighlightWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final activeItems = watch(productProvider);
    final inactiveItems = watch(productProvider).inactiveItems;

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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                      child: Text(
                        activeItems.activeItems.length.toString(),
                        style: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
                        ),
                      ),
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
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(7.5)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                      child: Text(
                        inactiveItems.length.toString(),
                        style: TextStyle(
                          color: Colors.white60,
                          fontWeight: FontWeight.w800,
                          fontSize: 25.0,
                        ),
                      ),
                      // }),
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
