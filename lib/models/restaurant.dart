import 'package:project_flutter/models/product.dart';

class Restaurant {
  final int id;
  final String name;
  final List<Product> products;

  Restaurant({
    required this.id,
    required this.name,
    this.products = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      products: json['products'] != null 
          ? List<Product>.from(json['products'].map((x) => Product.fromJson(x)))
          : [],
    );
  }
}