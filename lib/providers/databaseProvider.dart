// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:path/path.dart' as path;

// class DataBaseProvider {
//   DataBaseProvider() {
//     // this will run when provider is instantiate the first time
//     init();
//   }

//   static final tableName = 'product';
//   sql.Database db;

//   void init() async {
//     // void v4
//     void _createV4(sql.Batch batch) {
//       batch.execute(
//           "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, internationalWarranty INTEGER, online INTEGER, purchasedAt TEXT, company TEXT, salesPerson TEXT, phone TEXT, email TEXT, website TEXT, notes TEXT, productImage BLOB, purchaseCopy BLOB, warrantyCopy BLOB, additionalImage BOLB, category TEXT, tags TEXT, profile TEXT, productImagePath TEXT, purchaseCopyPath TEXT, warrantyCopyPath TEXT, additionalImagePath TEXT)");
//     }

//     // upgrade from v1, v2 to v4
//     void _upgradeFromV1ToV4(sql.Batch batch) {
//       batch.execute('ALTER TABLE product ADD productImage BLOB END');
//       batch.execute('ALTER TABLE product ADD category TEXT END');
//       batch.execute('ALTER TABLE product ADD tags TEXT END');
//       batch.execute('ALTER TABLE product ADD profile TEXT END');
//       batch.execute('ALTER TABLE product ADD productImagePath TEXT END');
//       batch.execute('ALTER TABLE product ADD purchaseCopyPath TEXT END');
//       batch.execute('ALTER TABLE product ADD warrantyCopyPath TEXT END');
//       batch.execute('ALTER TABLE product ADD additionalImagePath TEXT END');
//     }

//     // upgrade from v1, v2 to v4
//     void _upgradeFromV2ToV4(sql.Batch batch) {
//       batch.execute('ALTER TABLE product ADD productImagePath TEXT END');
//       batch.execute('ALTER TABLE product ADD purchaseCopyPath TEXT END');
//       batch.execute('ALTER TABLE product ADD warrantyCopyPath TEXT END');
//       batch.execute('ALTER TABLE product ADD additionalImagePath TEXT END');
//     }

//     final dbPath = await sql.getDatabasesPath();
//     db = await sql.openDatabase(
//       path.join(dbPath, 'product.db'),
//       version: 4,
//       onCreate: (db, version) async {
//         var batch = db.batch();
//         _createV4(batch);
//         await batch.commit(continueOnError: true);
//       },
//       onUpgrade: (db, oldVersion, newVersion) async {
//         var batch = db.batch();
//         if (oldVersion == 1 || oldVersion == 2) {
//           _upgradeFromV1ToV4(batch);
//         } else if (oldVersion == 3) {
//           _upgradeFromV2ToV4(batch);
//         }
//         await batch.commit(continueOnError: true);
//       },
//       onDowngrade: sql.onDatabaseDowngradeDelete,
//     );
//   }

//   Future<void> insert(String table, Map<String, Object> data) async {
//     await db.insert(table, data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getData(String table) async {
//     return await db.query(table);
//   }
// }
