// lib/models/order_model.dart
class Order {
  final String orderId;
  final String date;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  String paymentStatus;
  String status;
  final String transactionId;
  final String ownerPhone;

  Order({
    required this.orderId,
    required this.date,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.transactionId,
    required this.ownerPhone,
  });
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String unit;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.unit,
  });
}
