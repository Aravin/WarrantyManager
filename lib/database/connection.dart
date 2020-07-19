import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final Future<Database> database = getDatabasesPath().then((String path) {
  return openDatabase(
    join(path, 'product.db'),
    // When the database is first created, create a table to store
    onCreate: (db, version) async {
      return db.execute(
        "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, purchasedAt TEXT, brand TEXT, salesPerson TEXT, phone TEXT, email TEXT, notes TEXT )",
      );
    },
    version: 1,
  );
});
