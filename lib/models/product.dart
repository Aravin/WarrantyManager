// ref: https://noxasch.tech/blog/flutter-using-sqflite-with-riverpod/

import 'dart:async';
import 'dart:typed_data';
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
        );
      });
    } catch (err) {
      return await getProducts(retry: true); // getProducts(retry: true);
    }
  }

  // Define a function that inserts dogs into the database
  Future<void> insertProduct() async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same product is inserted twice.
    //

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
      productImage: this.productImage,
      purchaseCopy: this.purchaseCopy,
      warrantyCopy: this.warrantyCopy,
      additionalImage: this.additionalImage,
      category: this.category,
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
      productImage: this.productImage,
      purchaseCopy: this.purchaseCopy,
      warrantyCopy: this.warrantyCopy,
      additionalImage: this.additionalImage,
      category: this.category,
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

  Future<void> customQuery1() async {
    // Get a reference to the database.
    final db = await database;

    db.execute(
      "DROP table product",
    );
  }

  // unused
  // Future<void> customQuery2() async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   db.execute(
  //     "CREATE TABLE product(id INTEGER PRIMARY KEY, name TEXT, price REAL, purchaseDate TEXT, warrantyPeriod TEXT, warrantyEndDate TEXT, purchasedAt TEXT, company TEXT, salesPerson TEXT, phone TEXT, email TEXT, notes TEXT )",
  //   );
  // }
}
