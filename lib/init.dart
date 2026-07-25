import 'dart:io';
import 'dart:typed_data';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranty_manager/initilization/firebase.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/file.dart';

class AppInitialization {
  AppInitialization._();

  // 1. shared shared_preferences
  static late SharedPreferences _prefs;

  // 2. App directory
  static late Directory directory;

  // 3. Product
  static final Product _product = Product();

  static Future init() async {
    await FirebaseInit.instance;
    _prefs = await SharedPreferences.getInstance();
    directory = await getApplicationDocumentsDirectory();
    await MobileAds.instance.initialize();
    await _migrateBlobToPath();
  }

  static Future<void> _migrateBlobToPath() async {
    // step 1: is already migrated
    final bool isMigrated = _prefs.getBool('migratedBlobToPath') ?? false;

    if (isMigrated) {
      return;
    }

    // step 2: get row count
    final int productCount = await _product.getProductCount();

    if (productCount == 0) {
      return;
    }

    // step 3: Convert to blob / save to new column / del existing col
    for (var i = 0; i <= productCount; i++) {
      await _updateAndSaveImage('productImage', 'productImagePath', i);
      await _updateAndSaveImage('purchaseCopy', 'purchaseCopyPath', i);
      await _updateAndSaveImage('warrantyCopy', 'warrantyCopyPath', i);
      await _updateAndSaveImage('additionalImage', 'additionalImagePath', i);
    }

    _prefs.setBool('epix - migratedBlobToPath', true);
  }

  static Future<void> _updateAndSaveImage(
      String oldColumn, String newCOlumn, int row) async {
    // product image
    final List<Map<String, dynamic>> img =
        await _product.getProductColumn(['id', oldColumn], row);

    if (img.isNotEmpty) {
      // debugPrint('epix blob len - ${img.length}');
      final Uint8List blob = img[0][oldColumn] as Uint8List;
      final int columnId = img[0]['id'] as int;

      final String imgPath = await saveBolbAsImagePath(blob);

      if (imgPath.isNotEmpty) {
        await _product.updateColumn(columnId, newCOlumn, imgPath);
        await _product.deleteColumn(columnId, oldColumn);
      }
    }
  }
}
