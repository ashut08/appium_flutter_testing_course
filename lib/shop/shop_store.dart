import 'package:flutter/material.dart';

class ShopProduct {
  const ShopProduct(this.id, this.name, this.price);
  final int id;

  final String name;
  final int price;
}

const _catalog = [
  ('Apple', 120),
  ('Orange', 80),
  ('Pineapple', 150),
  ('Litchi', 200),
  ('Grapes', 90),
];

List<ShopProduct> _initialProduct() => [
  for (var id = 1; id <= 20; id++)
    ShopProduct(id, _catalog[(id - 1) % 5].$1, _catalog[(id - 1) % 5].$2),
];

class ShopStore {
  static final products = ValueNotifier<List<ShopProduct>>(_initialProduct());

  static final cartCount = ValueNotifier<int>(0);

  static void addToCart(int quantity) => cartCount.value += quantity;

  static void remove(ShopProduct product) {
    products.value = products.value
        .where((element) => element.id != product.id)
        .toList();
  }

  static void clearCart() => cartCount.value = 0;
}
