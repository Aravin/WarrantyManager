import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranty_manager/initilization/firebase.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/file.dart';

class AppInitialization {
  // Create the initialization Future outside of `build`:
  // 1. firebase
  static FirebaseApp _firebaseInit;

  // 2. shared shared_preferences
  static SharedPreferences _prefs;

  // 3. App directory
  static Directory directory;

  // 4. Product
  static Product _product = Product();

  static Future Init() async {
    _firebaseInit = await FirebaseInit.instance;
    _prefs = await SharedPreferences.getInstance();
    directory = await getApplicationDocumentsDirectory();
    await _migrateBlobToPath();
  }

  static _migrateBlobToPath() async {
    // step 1: is already migrated
    bool isMigrated = _prefs.getBool('migratedBlobToPath') ?? false;

    // print('epix - isMigrated $isMigrated');

    if (isMigrated) {
      return;
    }

    // step 2: get row count
    int productCount = await _product.getProductCount();

    if (productCount == 0) {
      return;
    }

    // step 3: Convert to blob / save to new column / del existing col
    for (var i = 0; i <= productCount; i++) {
      // print('epix - i - $i');

      await _updateAndSaveImage('productImage', 'productImagePath', i);
      await _updateAndSaveImage('purchaseCopy', 'purchaseCopyPath', i);
      await _updateAndSaveImage('warrantyCopy', 'warrantyCopyPath', i);
      await _updateAndSaveImage('additionalImage', 'additionalImagePath', i);
    }

    _prefs.setBool('epix - migratedBlobToPath', true);
  }

  static _updateAndSaveImage(
      String oldColumn, String newCOlumn, int row) async {
    // product image
    List<Map<String, Object>> img =
        await _product.getProductColumn(['id', oldColumn], row);

    if (img != null && img.length > 0) {
      print('epix blob len - ${img.length}');
      Uint8List blob = img[0][oldColumn] as Uint8List;
      int columnId = img[0]['id'] as int;

      // await _product.reproduceIssue(columnId);
      String imgPath =
          (blob != null && blob != '') ? await saveBolbAsImagePath(blob) : null;

      // print('epix img - ${imgPath}');

      if (imgPath != null) {
        await _product.updateColumn(columnId, newCOlumn, imgPath);

        await _product.deleteColumn(columnId, oldColumn);
      }

      // print('epix blob - $blob - $columnId');
    }
  }
}
