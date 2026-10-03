import 'package:appiumtesting/list_details_page.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items")),

      body: ListView.builder(
        key: const ValueKey('product_list'),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: ValueKey('product_$index'),
            title: Text(products[index].name),
            subtitle: Text("${products[index].price}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(model: products[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductModel {
  final double price;
  final String name;

  ProductModel({required this.price, required this.name});
}

final List<ProductModel> products = [
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),

  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
  ProductModel(price: 12.99, name: "Apple"),
  ProductModel(price: 14.99, name: "Orange"),
  ProductModel(price: 15.99, name: "Pineapple"),
  ProductModel(price: 15.99, name: "Litchi"),
  ProductModel(price: 19.99, name: "Grapes"),
];
