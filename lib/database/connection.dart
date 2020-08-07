import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final Future<Database> database = getDatabasesPath().then((String path) {
  return openDatabase(
    join(path, 'product.db'),
    // When the database is first created, create a table to store
    onCreate: (db, version) async {
      return db.execute(
        "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, internationalWarranty INTEGER, online INTEGER, purchasedAt TEXT, company TEXT, salesPerson TEXT, phone TEXT, email TEXT, website TEXT, notes TEXT, purchaseCopy BLOB, warrantyCopy BLOB, additionalImage BOLB)",
      );
    },
    version: 1,
  );
});
