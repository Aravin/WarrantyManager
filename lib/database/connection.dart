import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// v1 - testing
// v2 - main release
// v3 - added blob type for image
// v4 - fix for large image - store image in file instead of db

final Future<Database> database = getDatabasesPath().then(
  (String path) {
    // void v4
    void _createV4(Batch batch) {
      batch.execute(
          "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, internationalWarranty INTEGER, online INTEGER, purchasedAt TEXT, company TEXT, salesPerson TEXT, phone TEXT, email TEXT, website TEXT, notes TEXT, productImage BLOB, purchaseCopy BLOB, warrantyCopy BLOB, additionalImage BOLB, category TEXT, tags TEXT, profile TEXT, productImagePath TEXT, purchaseCopyPath TEXT, warrantyCopyPath TEXT, additionalImagePath TEXT)");
    }

    // upgrade from v1, v2 to v4
    void _upgradeFromV1ToV4(Batch batch) {
      batch.execute('ALTER TABLE product ADD productImage BLOB END');
      batch.execute('ALTER TABLE product ADD category TEXT END');
      batch.execute('ALTER TABLE product ADD tags TEXT END');
      batch.execute('ALTER TABLE product ADD profile TEXT END');
      batch.execute('ALTER TABLE product ADD productImagePath TEXT END');
      batch.execute('ALTER TABLE product ADD purchaseCopyPath TEXT END');
      batch.execute('ALTER TABLE product ADD warrantyCopyPath TEXT END');
      batch.execute('ALTER TABLE product ADD additionalImagePath TEXT END');
    }

    // upgrade from v1, v2 to v4
    void _upgradeFromV2ToV4(Batch batch) {
      batch.execute('ALTER TABLE product ADD productImagePath TEXT END');
      batch.execute('ALTER TABLE product ADD purchaseCopyPath TEXT END');
      batch.execute('ALTER TABLE product ADD warrantyCopyPath TEXT END');
      batch.execute('ALTER TABLE product ADD additionalImagePath TEXT END');
    }

    return openDatabase(
      join(path, 'product.db'),
      version: 4,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createV4(batch);
        await batch.commit(continueOnError: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1 || oldVersion == 2) {
          _upgradeFromV1ToV4(batch);
        } else if (oldVersion >= 3) {
          _upgradeFromV2ToV4(batch);
        }
        await batch.commit(continueOnError: true);
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  },
);
