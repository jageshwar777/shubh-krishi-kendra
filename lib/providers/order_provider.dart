// lib/providers/order_provider.dart
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> getOrders() {
    return List.from(_orders.reversed);
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }
}
