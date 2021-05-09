// ref: https://noxasch.tech/blog/flutter-using-sqflite-with-riverpod/

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:warranty_manager/database/connection.dart';

class Product {
  Product({
    this.id,
    this.name,
    this.price,
    this.purchaseDate,
    this.warrantyPeriod,
    this.warrantyEndDate,
    this.purchasedAt,
    this.company,
    this.salesPerson,
    this.phone,
    this.email,
    this.notes,
    this.productImage,
    this.purchaseCopy,
    this.warrantyCopy,
    this.additionalImage,
    this.category,
    this.productImagePath,
    this.purchaseCopyPath,
    this.warrantyCopyPath,
    this.additionalImagePath,
  }) {
    if (this.warrantyEndDate == null && this.warrantyPeriod != null) {
      if (this.warrantyPeriod.toLowerCase().indexOf('month') > 0) {
        var monthToAdd = int.parse(
            this.warrantyPeriod.replaceAll(new RegExp(r'[^0-9]'), ''));
        var tempDate = this.purchaseDate;
        this.warrantyEndDate = new DateTime(
          tempDate.year,
          tempDate.month + monthToAdd,
          tempDate.day,
          tempDate.hour,
        );
      } else if (this.warrantyPeriod.toLowerCase().indexOf('year') > 0) {
        var yearToAdd = int.parse(
            this.warrantyPeriod.replaceAll(new RegExp(r'[^0-9]'), ''));
        var tempDate = this.purchaseDate;
        this.warrantyEndDate = new DateTime(
          tempDate.year + yearToAdd,
          tempDate.month,
          tempDate.day,
          tempDate.hour,
        );
      }
    }
  }

  int id;
  String name;
  double price; // todo
  DateTime purchaseDate;
  String warrantyPeriod;
  String purchasedAt;
  String company;
  String salesPerson;
  String phone;
  String email;
  String notes;

  // calculated field
  DateTime warrantyEndDate;

  // images
  Uint8List productImage;
  Uint8List purchaseCopy;
  Uint8List warrantyCopy;
  Uint8List additionalImage;

  // added later
  String category;

  // paths
  String productImagePath;
  String purchaseCopyPath;
  String warrantyCopyPath;
  String additionalImagePath;

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'warrantyPeriod': warrantyPeriod,
      'warrantyEndDate': warrantyEndDate.toIso8601String(),
      'purchasedAt': purchasedAt,
      'company': company,
      'salesPerson': salesPerson,
      'phone': phone,
      'email': email,
      'notes': notes,
      'productImage': productImage,
      'purchaseCopy': purchaseCopy,
      'warrantyCopy': warrantyCopy,
      'additionalImage': additionalImage,
      'category': category,
      'productImagePath': productImagePath,
      'purchaseCopyPath': purchaseCopyPath,
      'warrantyCopyPath': warrantyCopyPath,
      'additionalImagePath': additionalImagePath,
    };
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Product>> getProducts({bool retry = false}) async {
    try {
      // Get a reference to the database.
      final Database db = await database;

      List<String> columns = [];

      if (retry) {
        columns = [
          'id',
          'name',
          'price',
          'purchaseDate',
          'warrantyPeriod',
          'warrantyEndDate',
          'purchasedAt',
          'company',
          'salesPerson',
          'phone',
          'email',
          'notes',
          // 'productImage',
          // 'purchaseCopy',
          // 'warrantyCopy',
          // 'additionalImage',
          'category',
          'productImagePath',
          'purchaseCopyPath',
          'warrantyCopyPath',
          'additionalImagePath',
        ];
      }

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps =
          await db.query('product', columns: columns);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          purchaseDate: DateTime.parse(maps[i]['purchaseDate']),
          warrantyPeriod: maps[i]['warrantyPeriod'],
          warrantyEndDate: DateTime.parse(maps[i]['warrantyEndDate']),
          purchasedAt: maps[i]['purchasedAt'],
          company: maps[i]['company'],
          salesPerson: maps[i]['salesPerson'],
          phone: maps[i]['phone'],
          email: maps[i]['email'],
          notes: maps[i]['notes'],
          productImage: maps[i]['productImage'],
          purchaseCopy: maps[i]['purchaseCopy'],
          warrantyCopy: maps[i]['warrantyCopy'],
          additionalImage: maps[i]['additionalImage'],
          category: maps[i]['category'],
          productImagePath: maps[i]['productImagePath'],
          purchaseCopyPath: maps[i]['purchaseCopyPath'],
          warrantyCopyPath: maps[i]['warrantyCopyPath'],
          additionalImagePath: maps[i]['additionalImagePath'],
        );
      });
    } catch (err) {
      print('epix - retry called - $err');
      return await getProducts(retry: true); // getProducts(retry: true);
    }
  }

  // Define a function that inserts dogs into the database
  Future<void> insertProduct() async {
    // Get a reference to the database.
    final Database db = await database;

    // Create a Dog and add it to the dogs table.
    final productToInsert = Product(
      id: this.id,
      name: this.name,
      price: this.price,
      purchaseDate: this.purchaseDate,
      warrantyPeriod: this.warrantyPeriod,
      warrantyEndDate: this.warrantyEndDate,
      purchasedAt: this.purchasedAt,
      company: this.company,
      salesPerson: this.salesPerson,
      phone: this.phone,
      email: this.email,
      notes: this.notes,
      // productImage: this.productImage,
      // purchaseCopy: this.purchaseCopy,
      // warrantyCopy: this.warrantyCopy,
      // additionalImage: this.additionalImage,
      category: this.category,
      productImagePath: this.productImagePath,
      purchaseCopyPath: this.purchaseCopyPath,
      warrantyCopyPath: this.warrantyCopyPath,
      additionalImagePath: this.additionalImagePath,
    );
    // In this case, replace any previous data.
    await db.insert(
      'product',
      productToInsert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct() async {
    // Get a reference to the database.
    final db = await database;

    // Create a Dog and add it to the dogs table.
    final productToUpdate = Product(
      id: this.id,
      name: this.name,
      price: this.price,
      purchaseDate: this.purchaseDate,
      warrantyPeriod: this.warrantyPeriod,
      warrantyEndDate: this.warrantyEndDate,
      purchasedAt: this.purchasedAt,
      company: this.company,
      salesPerson: this.salesPerson,
      phone: this.phone,
      email: this.email,
      notes: this.notes,
      // productImage: this.productImage,
      // purchaseCopy: this.purchaseCopy,
      // warrantyCopy: this.warrantyCopy,
      // additionalImage: this.additionalImage,
      category: this.category,
      productImagePath: this.productImagePath,
      purchaseCopyPath: this.purchaseCopyPath,
      warrantyCopyPath: this.warrantyCopyPath,
      additionalImagePath: this.additionalImagePath,
    );

    // TODO: remove duplicate code
    if (productToUpdate.warrantyPeriod.toLowerCase().indexOf('month') > 0) {
      var monthToAdd = int.parse(
          productToUpdate.warrantyPeriod.replaceAll(new RegExp(r'[^0-9]'), ''));
      var tempDate = productToUpdate.purchaseDate;
      productToUpdate.warrantyEndDate = new DateTime(
        tempDate.year,
        tempDate.month + monthToAdd,
        tempDate.day,
        tempDate.hour,
      );
    } else if (productToUpdate.warrantyPeriod.toLowerCase().indexOf('year') >
        0) {
      var yearToAdd = int.parse(
          productToUpdate.warrantyPeriod.replaceAll(new RegExp(r'[^0-9]'), ''));
      var tempDate = productToUpdate.purchaseDate;
      productToUpdate.warrantyEndDate = new DateTime(
        tempDate.year + yearToAdd,
        tempDate.month,
        tempDate.day,
        tempDate.hour,
      );
    }

    // Update the given Dog.
    await db.update(
      'product',
      productToUpdate.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [productToUpdate.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the Database.
    await db.delete(
      'product',
      // Use a `where` clause to delete a specific product.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteProducts() async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the Database.
    await db.delete('product');
  }

  Future<int> getProductCount() async {
    // Get a reference to the database.
    final db = await database;

    return await Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(1) FROM product'));
  }

  // for blob to path conversion
  Future<List<Map<String, Object>>> getProductColumn(
      List<String> columns, int offset) async {
    // Get a reference to the database.
    final db = await database;

    return await db.query('product',
        columns: columns, limit: 1, offset: offset, orderBy: 'id');
  }

  updateColumn(int id, String column, String val) async {
    // Get a reference to the database.
    final db = await database;

    return await db.execute(
      'UPDATE product SET $column = ? WHERE Id = ?',
      [val, id],
    );
  }

  deleteColumn(int id, String column) async {
    // Get a reference to the database.
    final db = await database;

    return await db.execute(
      'UPDATE product SET $column = null WHERE Id = ?',
      [id],
    );
  }

  // end of -- for blob to path conversion

  // unused
  Future<void> reproduceIssue(int columnId) async {
    // Get a reference to the database.
    final db = await database;
    String imagePath =
        '/data/user/0/io.epix.warranty_manager/app_flutter/products/1620546857245.jpg';
    final Uint8List blob = _fileToBlob(File(imagePath));

    db.execute(
        "UPDATE product SET productImagePath = ?, purchaseCopyPath = ?, warrantyCopyPath = ?, additionalImagePath = ? WHERE Id = ?",
        [null, null, null, null, columnId]);

    db.execute(
        "UPDATE product SET productImage = ?, purchaseCopy = ?, warrantyCopy = ?, additionalImage = ? WHERE Id = ?",
        [blob, blob, blob, blob, columnId]);
  }
}

// this.productImagePath,
// this.purchaseCopyPath,
// this.warrantyCopyPath,
// this.additionalImagePath

Uint8List _fileToBlob(File file) {
  if (file != null) {
    return file.readAsBytesSync();
  }
  return null;
}
