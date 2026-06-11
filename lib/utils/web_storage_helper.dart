import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class WebStorageHelper {
  static List<Product> _products = [];
  static const String _productsKey = 'products_data';

  static Future<void> init() async {
    await loadProducts();
  }

  static Future<void> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_productsKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _products = jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        await _loadDefaultProducts();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Load products error: $e');
      }
      await _loadDefaultProducts();
    }
  }

  static Future<void> _loadDefaultProducts() async {
    _products = [
      Product(
          id: '1',
          name: 'धान का बीज',
          category: 'बीज',
          price: 450,
          unit: 'KG',
          stock: 100,
          imageUrl: ''),
      Product(
          id: '2',
          name: 'गेहूं का बीज',
          category: 'बीज',
          price: 380,
          unit: 'KG',
          stock: 85,
          imageUrl: ''),
      Product(
          id: '3',
          name: 'यूरिया खाद',
          category: 'खाद',
          price: 280,
          unit: 'KG',
          stock: 50,
          imageUrl: ''),
      Product(
          id: '4',
          name: 'DAP खाद',
          category: 'खाद',
          price: 1350,
          unit: 'KG',
          stock: 30,
          imageUrl: ''),
      Product(
          id: '5',
          name: 'ग्लाइफोसेट',
          category: 'कीटनाशक',
          price: 350,
          unit: 'ML',
          stock: 40,
          imageUrl: ''),
      Product(
          id: '6',
          name: 'क्लोरोपायरीफोस',
          category: 'कीटनाशक',
          price: 420,
          unit: 'ML',
          stock: 25,
          imageUrl: ''),
    ];
    await saveProducts();
  }

  static Future<void> saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _products.map((product) => product.toJson()).toList();
      await prefs.setString(_productsKey, json.encode(jsonList));
    } catch (e) {
      if (kDebugMode) {
        print('Save products error: $e');
      }
    }
  }

  static List<Product> getProducts() {
    return List.from(_products);
  }

  static List<Product> getProductsByCategory(String category) {
    if (category == 'सभी') {
      return List.from(_products);
    }
    return _products.where((product) => product.category == category).toList();
  }

  static List<String> getCategories() {
    final List<String> categories =
        _products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'सभी');
    return categories;
  }

  static Future<void> importProductsFromJson(String jsonString) async {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      _products = jsonList.map((json) => Product.fromJson(json)).toList();
      await saveProducts();
    } catch (e) {
      throw Exception('JSON import error: $e');
    }
  }

  static Future<String> exportProductsToJson() async {
    final jsonList = _products.map((product) => product.toJson()).toList();
    return json.encode(jsonList);
  }
}
