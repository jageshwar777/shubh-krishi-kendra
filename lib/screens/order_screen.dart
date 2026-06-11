// lib/screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.getOrders();

    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80),
            SizedBox(height: 16),
            Text('कोई ऑर्डर नहीं'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(order: order);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status),
          child: Icon(_getStatusIcon(order.status), color: Colors.white),
        ),
        title: Text(
            'ऑर्डर #${order.orderId.substring(0, order.orderId.length > 8 ? 8 : order.orderId.length)}'),
        subtitle:
            Text('${order.date.substring(0, 16)} | ₹${order.totalAmount}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('👤 ग्राहक जानकारी',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('नाम: ${order.customerName}'),
                      Text('मोबाइल: ${order.customerPhone}'),
                      Text('पता: ${order.customerAddress}'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('📦 सामान',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                                  '${item.productName} x ${item.quantity} ${item.unit}')),
                          Text(
                              '₹${(item.price * item.quantity).toStringAsFixed(0)}'),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('कुल रकम:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${order.totalAmount.toStringAsFixed(0)}'),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(_generateInvoice());
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('इनवॉइस शेयर करें'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.pending;
      case 'Confirmed':
        return Icons.check_circle;
      case 'Completed':
        return Icons.done_all;
      default:
        return Icons.receipt;
    }
  }

  String _generateInvoice() {
    return """
╔══════════════════════════════════════╗
║         गाँव की दुकान                ║
║         === इनवॉइस ===              ║
╠══════════════════════════════════════╣
║ ऑर्डर ID: ${order.orderId}          
║ दिनांक: ${order.date}               
╠══════════════════════════════════════╣
║ ग्राहक जानकारी:                     
║ नाम: ${order.customerName}           
║ मोबाइल: ${order.customerPhone}      
║ पता: ${order.customerAddress}        
╠══════════════════════════════════════╣
║ सामान की जानकारी:                    
${order.items.map((item) => '║ ${item.productName} x ${item.quantity} ${item.unit} = ₹${(item.price * item.quantity).toStringAsFixed(0)}').join('\n')}
╠══════════════════════════════════════╣
║ कुल रकम: ₹${order.totalAmount.toStringAsFixed(0)}        
║ पेमेंट: ${order.paymentMethod}       
║ स्थिति: ${order.paymentStatus}       
╚══════════════════════════════════════╝
    """;
  }
}
