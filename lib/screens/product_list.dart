import 'package:flutter/material.dart';
import 'package:warranty_manager/widgets/product_page.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Saved Items',
        ),
      ),
      body: Column(
        children: <Widget>[ProductListWidget()],
      ),
    );
  }
}
