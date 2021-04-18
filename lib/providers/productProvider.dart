import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:warranty_manager/providers/databaseProvider.dart';
import 'package:warranty_manager/models/product.dart';

final productProvider = ChangeNotifierProvider<ProductProvider>((ref) {
  return ProductProvider(ref);
});

class ProductProvider with ChangeNotifier {
  final ProviderReference ref;
  List<Product> _items = [];
  final tableName = 'product';

  ProductProvider(this.ref) {
    if (ref != null) fetchAndSetData();
  }

  List<Product> get items => [..._items];
  List<Product> get activeItems => [
        ...items.where((e) => DateTime.parse(e.warrantyEndDate.toString())
            .isAfter(DateTime.now()))
      ];
  List<Product> get inactiveItems => [
        ...items.where((e) => DateTime.parse(e.warrantyEndDate.toString())
            .isBefore(DateTime.now()))
      ];
  // List<Product> get items => [..._items];

  void addProduct(Product product) {
    final db = ref.read(dbProvider).db;
    if (db != null) {
      // do not execute if db is not instantiate
      _items.add(product);
      notifyListeners();
      ref.read(dbProvider).insert(tableName, product.toMap());
    }
  }

  Future<void> fetchAndSetData() async {
    print('ara fetchAndSetData called');
    final db = ref.read(dbProvider).db;
    print('ara ${db.toString()}');
    if (db != null) {
      // do not execute if db is not instantiate
      final dataList = await ref.read(dbProvider).getData(tableName);
      _items = dataList
          .map(
            (item) => Product(
              id: item['id'],
              name: item['name'],
              price: item['price'],
              purchaseDate: DateTime.parse(item['purchaseDate']),
              warrantyPeriod: item['warrantyPeriod'],
              warrantyEndDate: DateTime.parse(item['warrantyEndDate']),
              purchasedAt: item['purchasedAt'],
              company: item['company'],
              salesPerson: item['salesPerson'],
              phone: item['phone'],
              email: item['email'],
              notes: item['notes'],
              productImage: item['productImage'],
              purchaseCopy: item['purchaseCopy'],
              warrantyCopy: item['warrantyCopy'],
              additionalImage: item['additionalImage'],
              category: item['category'],
            ),
          )
          .toList();

      print('ara' + _items.toString());
      notifyListeners();
    }
  }
}
