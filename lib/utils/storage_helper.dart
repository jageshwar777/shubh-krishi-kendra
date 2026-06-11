import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';

class StorageHelper {
  static List<Product> _products = [];

  static Future<void> init() async {
    try {
      await loadProducts();
    } catch (e) {
      debugPrint('Storage init error: $e');
      _products = [];
      await _loadDefaultProducts();
    }
  }

  static Future<void> loadProducts() async {
    try {
      final file = await _getProductsFile();

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        if (jsonString.isNotEmpty) {
          final List<dynamic> jsonList = json.decode(jsonString);
          _products = jsonList.map((json) => Product.fromJson(json)).toList();
        } else {
          await _loadDefaultProducts();
        }
      } else {
        await _loadDefaultProducts();
      }
    } catch (e) {
      debugPrint('Load products error: $e');
      await _loadDefaultProducts();
    }
  }

  static Future<void> _loadDefaultProducts() async {
    try {
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
    } catch (e) {
      debugPrint('Default products error: $e');
    }
  }

  static Future<void> saveProducts() async {
    try {
      final file = await _getProductsFile();
      final jsonList = _products.map((product) => product.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Save products error: $e');
    }
  }

  static List<Product> getProducts() {
    try {
      return List.from(_products);
    } catch (e) {
      debugPrint('Get products error: $e');
      return [];
    }
  }

  static List<Product> getProductsByCategory(String category) {
    try {
      if (category == 'सभी') {
        return List.from(_products);
      }
      return _products
          .where((product) => product.category == category)
          .toList();
    } catch (e) {
      debugPrint('Get products by category error: $e');
      return [];
    }
  }

  static List<String> getCategories() {
    try {
      final List<String> categories =
          _products.map((p) => p.category).toSet().toList();
      categories.insert(0, 'सभी');
      return categories;
    } catch (e) {
      debugPrint('Get categories error: $e');
      return ['सभी'];
    }
  }

  static Future<void> importProductsFromJson(String jsonString) async {
    try {
      final decoded = json.decode(jsonString);

      if (decoded is! List) {
        throw Exception(
            'JSON must be an array/list. Got ${decoded.runtimeType}');
      }

      final List<dynamic> jsonList = decoded;

      for (int i = 0; i < jsonList.length; i++) {
        final item = jsonList[i];
        if (item is! Map<String, dynamic>) {
          throw Exception('Item at index $i is not a valid product object');
        }

        final requiredFields = [
          'id',
          'name',
          'category',
          'price',
          'unit',
          'stock'
        ];
        for (final field in requiredFields) {
          if (!item.containsKey(field)) {
            throw Exception(
                'Missing required field "$field" in product at index $i');
          }
        }

        if (item['price'] is! num) {
          throw Exception('Price must be a number at index $i');
        }

        if (item['stock'] is! int) {
          throw Exception('Stock must be an integer at index $i');
        }
      }

      _products = jsonList.map((json) => Product.fromJson(json)).toList();
      await saveProducts();
    } on FormatException catch (e) {
      debugPrint('JSON Format Error: $e');
      throw Exception(
          '❌ Invalid JSON format. Please check your JSON syntax.\n\nError: ${e.message}');
    } catch (e) {
      debugPrint('Import error: $e');
      throw Exception('❌ Import failed: $e');
    }
  }

  static Future<String> exportProductsToJson() async {
    try {
      final jsonList = _products.map((product) => product.toJson()).toList();
      return json.encode(jsonList);
    } catch (e) {
      debugPrint('Export JSON error: $e');
      return '[]';
    }
  }

  static Future<File> _getProductsFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/products.json');
    } catch (e) {
      debugPrint('Get products file error: $e');
      throw Exception('Cannot access storage');
    }
  }
}
