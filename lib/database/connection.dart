import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final Future<Database> database = getDatabasesPath().then(
  (String path) {
    // current verion 2

    // create v2 table
    void _createV2(Batch batch) {
      batch.execute(
          "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, internationalWarranty INTEGER, online INTEGER, purchasedAt TEXT, company TEXT, salesPerson TEXT, phone TEXT, email TEXT, website TEXT, notes TEXT, productImage BLOB, purchaseCopy BLOB, warrantyCopy BLOB, additionalImage BOLB, category TEXT, tags TEXT, profile TEXT)");
    }

    // upgrade product table V2
    void _upgradeFrom1ToV2(Batch batch) {
      batch.execute('ALTER TABLE product ADD productImage BLOB END');
      batch.execute('ALTER TABLE product ADD purchaseCopy BLOB END');
      batch.execute('ALTER TABLE product ADD warrantyCopy BLOB END');
      batch.execute('ALTER TABLE product ADD additionalImage BLOB END');
      batch.execute('ALTER TABLE product ADD category TEXT END');
      batch.execute('ALTER TABLE product ADD tags TEXT END');
      batch.execute('ALTER TABLE product ADD profile TEXT END');
    }

    return openDatabase(
      join(path, 'product.db'),
      version: 2,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createV2(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _upgradeFrom1ToV2(batch);
        }
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  },
);
