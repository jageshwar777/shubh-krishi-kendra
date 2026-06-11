import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void addToCart(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Already in cart - increase quantity
      if (_items[existingIndex].quantity < product.stock) {
        _items[existingIndex].quantity++;
        notifyListeners();
      }
    } else {
      // New product - add with quantity 1
      if (product.stock > 0) {
        _items.add(CartItem(product: product, quantity: 1));
        notifyListeners();
      }
    }
  }

  void decreaseQuantity(Product product) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
        notifyListeners();
      } else {
        _items.removeAt(existingIndex);
        notifyListeners();
      }
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  int getQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}
