import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:warranty_manager/database/connection.dart';

class Product {
  Product({
    this.id = 0,
    this.name = '',
    this.price = 0.0,
    this.purchaseDate,
    this.warrantyPeriod = '',
    this.warrantyEndDate,
    this.purchasedAt = '',
    this.company = '',
    this.salesPerson = '',
    this.phone = '',
    this.email = '',
    this.notes = '',
    this.productImage,
    this.purchaseCopy,
    this.warrantyCopy,
    this.additionalImage,
    this.category = '',
    this.productImagePath,
    this.purchaseCopyPath,
    this.warrantyCopyPath,
    this.additionalImagePath,
  }) {
    if (purchaseDate != null && warrantyPeriod.isNotEmpty) {
      final dt = purchaseDate!;
      if (warrantyPeriod.toLowerCase().indexOf('month') > 0) {
        final monthToAdd = int.parse(
            warrantyPeriod.replaceAll(RegExp('[^0-9]'), ''));
        warrantyEndDate = DateTime(
          dt.year,
          dt.month + monthToAdd,
          dt.day,
          dt.hour,
        );
      } else if (warrantyPeriod.toLowerCase().indexOf('year') > 0) {
        final yearToAdd = int.parse(
            warrantyPeriod.replaceAll(RegExp('[^0-9]'), ''));
        warrantyEndDate = DateTime(
          dt.year + yearToAdd,
          dt.month,
          dt.day,
          dt.hour,
        );
      }
    }
  }

  late int id;
  late String name;
  late double price;
  DateTime? purchaseDate;
  String warrantyPeriod;
  late String purchasedAt;
  late String company;
  late String salesPerson;
  late String phone;
  late String email;
  late String notes;

  DateTime? warrantyEndDate;

  Uint8List? productImage;
  Uint8List? purchaseCopy;
  Uint8List? warrantyCopy;
  Uint8List? additionalImage;

  late String category;

  String? productImagePath;
  String? purchaseCopyPath;
  String? warrantyCopyPath;
  String? additionalImagePath;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'warrantyPeriod': warrantyPeriod,
      'warrantyEndDate': warrantyEndDate?.toIso8601String(),
      'purchasedAt': purchasedAt,
      'company': company,
      'salesPerson': salesPerson,
      'phone': phone,
      'email': email,
      'notes': notes,
      'productImage': productImage ?? Uint8List(0),
      'purchaseCopy': purchaseCopy ?? Uint8List(0),
      'warrantyCopy': warrantyCopy ?? Uint8List(0),
      'additionalImage': additionalImage ?? Uint8List(0),
      'category': category,
      'productImagePath': productImagePath,
      'purchaseCopyPath': purchaseCopyPath,
      'warrantyCopyPath': warrantyCopyPath,
      'additionalImagePath': additionalImagePath,
    };
  }

  Future<List<Product>> getProducts({bool retry = false}) async {
    try {
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
          'category',
          'productImagePath',
          'purchaseCopyPath',
          'warrantyCopyPath',
          'additionalImagePath',
        ];
      }

      final List<Map<String, dynamic>> maps =
          await db.query('product', columns: columns);

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
      // debugPrint('epix - retry called - $err');
      return await getProducts(retry: true);
    }
  }

  Future<void> insertProduct() async {
    final Database db = await database;

    final productToInsert = Product(
      id: id,
      name: name,
      price: price,
      purchaseDate: purchaseDate,
      warrantyPeriod: warrantyPeriod,
      warrantyEndDate: warrantyEndDate,
      purchasedAt: purchasedAt,
      company: company,
      salesPerson: salesPerson,
      phone: phone,
      email: email,
      notes: notes,
      category: category,
      productImagePath: productImagePath,
      purchaseCopyPath: purchaseCopyPath,
      warrantyCopyPath: warrantyCopyPath,
      additionalImagePath: additionalImagePath,
    );
    await db.insert(
      'product',
      productToInsert.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct() async {
    final db = await database;

    final productToUpdate = Product(
      id: id,
      name: name,
      price: price,
      purchaseDate: purchaseDate,
      warrantyPeriod: warrantyPeriod,
      warrantyEndDate: warrantyEndDate,
      purchasedAt: purchasedAt,
      company: company,
      salesPerson: salesPerson,
      phone: phone,
      email: email,
      notes: notes,
      category: category,
      productImagePath: productImagePath,
      purchaseCopyPath: purchaseCopyPath,
      warrantyCopyPath: warrantyCopyPath,
      additionalImagePath: additionalImagePath,
    );

    if (productToUpdate.warrantyPeriod.toLowerCase().indexOf('month') > 0) {
      final monthToAdd = int.parse(
          productToUpdate.warrantyPeriod.replaceAll(RegExp('[^0-9]'), ''));
      final tempDate = productToUpdate.purchaseDate!;
      productToUpdate.warrantyEndDate = DateTime(
        tempDate.year,
        tempDate.month + monthToAdd,
        tempDate.day,
        tempDate.hour,
      );
    } else if (productToUpdate.warrantyPeriod.toLowerCase().indexOf('year') >
        0) {
      final yearToAdd = int.parse(
          productToUpdate.warrantyPeriod.replaceAll(RegExp('[^0-9]'), ''));
      final tempDate = productToUpdate.purchaseDate!;
      productToUpdate.warrantyEndDate = DateTime(
        tempDate.year + yearToAdd,
        tempDate.month,
        tempDate.day,
        tempDate.hour,
      );
    }

    await db.update(
      'product',
      productToUpdate.toMap(),
      where: "id = ?",
      whereArgs: [productToUpdate.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;

    await db.delete(
      'product',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteProducts() async {
    final db = await database;

    await db.delete('product');
  }

  Future<int> getProductCount() async {
    final db = await database;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(1) FROM product')) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getProductColumn(
      List<String> columns, int offset) async {
    final db = await database;

    return await db.query('product',
        columns: columns, limit: 1, offset: offset, orderBy: 'id');
  }

  Future<void> updateColumn(int id, String column, String val) async {
    final db = await database;

    await db.execute(
      'UPDATE product SET $column = ? WHERE Id = ?',
      [val, id],
    );
  }

  Future<void> deleteColumn(int id, String column) async {
    final db = await database;

    await db.execute(
      'UPDATE product SET $column = null WHERE Id = ?',
      [id],
    );
  }

  Future<void> reproduceIssue(int columnId) async {
    final db = await database;
    const String imagePath =
        '/data/user/0/io.epix.warranty_manager/app_flutter/products/1620546857245.jpg';
    final Uint8List? blob = _fileToBlob(File(imagePath));

    db.execute(
        "UPDATE product SET productImagePath = ?, purchaseCopyPath = ?, warrantyCopyPath = ?, additionalImagePath = ? WHERE Id = ?",
        [null, null, null, null, columnId]);

    db.execute(
        "UPDATE product SET productImage = ?, purchaseCopy = ?, warrantyCopy = ?, additionalImage = ? WHERE Id = ?",
        [blob, blob, blob, blob, columnId]);
  }
}

Uint8List? _fileToBlob(File? file) {
  if (file != null) {
    return file.readAsBytesSync();
  }
  return null;
}
