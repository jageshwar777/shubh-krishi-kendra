import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = product.stock == 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Area
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Icon(
                _getIconForCategory(product.category),
                size: 50,
                color: Colors.green[700],
              ),
            ),
          ),

          // Product Info Area
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green),
                    ),
                    const SizedBox(width: 4),
                    Text('/ ${product.unit}',
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),

                // ✅ Quantity Button - पूरा responsive और working
                if (!isOutOfStock)
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: quantity == 0
                        ? InkWell(
                            onTap: onAdd,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  '+ झोले में डालें',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Minus Button
                              InkWell(
                                onTap: onRemove,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove,
                                        size: 18, color: Colors.red),
                                  ),
                                ),
                              ),
                              // Quantity Display
                              Container(
                                width: 40,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              // Plus Button
                              InkWell(
                                onTap: quantity < product.stock ? onAdd : null,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 40,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: quantity < product.stock
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),

                if (isOutOfStock)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'स्टॉक में नहीं',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'बीज':
        return Icons.grass;
      case 'खाद':
        return Icons.agriculture;
      case 'कीटनाशक':
        return Icons.bug_report;
      default:
        return Icons.shopping_bag;
    }
  }
}
