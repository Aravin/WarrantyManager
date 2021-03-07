import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/widgets/product_page.dart';
import 'package:warranty_manager/screens/add.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  actionCallback(bool rebuild) {
    if (rebuild) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Saved Items',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddItem(
                                  isUpdate: false,
                                )))
                        .then((value) => setState(() => {}))
                  }).circle(radius: 40, backgroundColor: secondaryColor),
        ],
      ),
      body: Column(
        children: <Widget>[ProductListWidget(actionCallback: actionCallback)],
      ),
    );
  }
}
