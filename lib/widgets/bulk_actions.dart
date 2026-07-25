import 'package:flutter/material.dart';
import 'package:warranty_manager/screens/bulk_delete.dart';
import 'package:warranty_manager/screens/bulk_export.dart';
import 'package:warranty_manager/screens/bulk_upload.dart';

class BulkActionScreen extends StatefulWidget {
  final int currentIndex;

  const BulkActionScreen({super.key, required this.currentIndex});

  @override
  _BulkActionScreenState createState() => _BulkActionScreenState();
}

class _BulkActionScreenState extends State<BulkActionScreen> {
  void _onItemTapped(int selectedIndex) {
    print('item tapped $selectedIndex');
    if (selectedIndex == widget.currentIndex) {
      return;
    }
    Widget page;
    if (selectedIndex == 0) {
      page = BulkUploadScreen();
    } else if (selectedIndex == 1) {
      page = BulkExportScreen();
    } else if (selectedIndex == 2) {
      page = BulkDeleteScreen();
    } else {
      page = BulkUploadScreen();
    }

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_file),
          label: 'Import',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.save_alt),
          label: 'Export',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delete_forever),
          label: 'Delete',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
      // selectedItemColor: Colors.amber[800],
      // unselectedItemColor: liteAccentColor,
      // backgroundColor: primaryColor,
    );
  }
}
