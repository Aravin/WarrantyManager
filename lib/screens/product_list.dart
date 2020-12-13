import 'package:flutter/material.dart';
import 'package:warranty_manager/widgets/product_page.dart';
import 'package:warranty_manager/screens/add.dart';

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
              icon: Icon(Icons.add_box_rounded),
              onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => AddItem(
                                  isUpdate: false,
                                )))
                        .then((value) => setState(() => {}))
                  }),
        ],
      ),
      body: Column(
        children: <Widget>[ProductListWidget(actionCallback: actionCallback)],
      ),
    );
  }
}
