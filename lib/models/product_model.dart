// lib/models/product_model.dart
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String unit;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.stock,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      stock: json['stock'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'unit': unit,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }
}
