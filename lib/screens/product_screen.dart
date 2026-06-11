import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/web_storage_helper.dart';
import '../widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedCategory = 'सभी';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    try {
      setState(() {
        _categories = WebStorageHelper.getCategories();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Load data error: $e');
      }
      setState(() {
        _categories = ['सभी'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final cartProvider = Provider.of<CartProvider>(context);
      final filteredProducts =
          WebStorageHelper.getProductsByCategory(_selectedCategory);

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green[50],
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.green),
                const SizedBox(width: 8),
                const Text('कैटेगरी:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                          value: category, child: Text(category));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('कोई सामान नहीं'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      try {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          quantity: cartProvider.getQuantity(product),
                          onAdd: () => cartProvider.addToCart(product),
                          onRemove: () =>
                              cartProvider.decreaseQuantity(product),
                        );
                      } catch (e) {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
          ),
        ],
      );
    } catch (e) {
      return const Center(
          child: Text('कुछ गलत हो गया, कृपया बाद में प्रयास करें'));
    }
  }
}
