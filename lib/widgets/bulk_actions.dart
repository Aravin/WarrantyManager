import 'package:flutter/material.dart';
import 'package:warranty_manager/screens/bulk_upload.dart';
import 'package:warranty_manager/screens/bulk_export.dart';
import 'package:warranty_manager/screens/bulk_delete.dart';

class BulkActionScreen extends StatefulWidget {
  final int currentIndex;

  BulkActionScreen({this.currentIndex});

  @override
  _BulkActionScreenState createState() => _BulkActionScreenState();
}

class _BulkActionScreenState extends State<BulkActionScreen> {
  void _onItemTapped(int _selectedIndex) {
    print('item tapped $_selectedIndex');
    if (_selectedIndex == widget.currentIndex) {
      return;
    }
    var page;
    if (_selectedIndex == 0) {
      page = BulkUploadScreen();
    }
    if (_selectedIndex == 1) {
      page = BulkExportScreen();
    }
    if (_selectedIndex == 2) {
      page = BulkDeleteScreen();
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
