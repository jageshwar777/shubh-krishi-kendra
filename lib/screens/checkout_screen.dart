import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isProcessing = false;
  String _selectedPaymentMethod = 'upi';
  String _upiId = 'shopowner@okhdfcbank';
  bool _isCodEnabled = true;
  Order? _lastOrder;

  @override
  void initState() {
    super.initState();
    _loadUpiId();
    _loadCodStatus();
  }

  Future<void> _loadUpiId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _upiId = prefs.getString('upi_id') ?? 'shopowner@okhdfcbank';
      });
    }
  }

  Future<void> _loadCodStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isCodEnabled = prefs.getBool('cod_enabled') ?? true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('पता और पेमेंट'),
        backgroundColor: Colors.green[700],
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('आपका ऑर्डर',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Divider(),
                            ...cartProvider.items.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text(
                                              '${item.product.name} x ${item.quantity}')),
                                      Text(
                                          '₹${(item.product.price * item.quantity).toStringAsFixed(0)}'),
                                    ],
                                  ),
                                )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('कुल रकम:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '₹${cartProvider.totalPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'पूरा नाम *',
                          border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? 'नाम लिखें' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          labelText: 'मोबाइल नंबर *',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v!.length != 10 ? '10 अंकों का नंबर' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                          labelText: 'पता *', border: OutlineInputBorder()),
                      maxLines: 2,
                      validator: (v) => v!.isEmpty ? 'पता लिखें' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('पेमेंट का तरीका',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    RadioListTile(
                      value: 'upi',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (v) =>
                          setState(() => _selectedPaymentMethod = v.toString()),
                      title: const Text('UPI पेमेंट (QR Code)'),
                      subtitle:
                          const Text('PhonePe, GooglePay, Paytm से स्कैन करें'),
                    ),
                    if (_isCodEnabled)
                      RadioListTile(
                        value: 'cod',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (v) => setState(
                            () => _selectedPaymentMethod = v.toString()),
                        title: const Text('कैश ऑन डिलीवरी (COD)'),
                        subtitle: const Text('सामान मिलने पर पैसे दें'),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _processOrder(cartProvider),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text('ऑर्डर कन्फर्म करें'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _processOrder(CartProvider cartProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // ऑर्डर बनाओ
    final order = Order(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now().toString(),
      customerName: _nameController.text,
      customerPhone: _phoneController.text,
      customerAddress: _addressController.text,
      items: cartProvider.items
          .map((item) => OrderItem(
                productId: item.product.id,
                productName: item.product.name,
                quantity: item.quantity,
                price: item.product.price,
                unit: item.product.unit,
              ))
          .toList(),
      totalAmount: cartProvider.totalPrice,
      paymentMethod: _selectedPaymentMethod,
      paymentStatus: _selectedPaymentMethod == 'upi' ? 'Pending' : 'Pending',
      status: _selectedPaymentMethod == 'upi' ? 'Pending' : 'Pending',
      transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerPhone: '919876543210',
    );

    Provider.of<OrderProvider>(context, listen: false).addOrder(order);
    _lastOrder = order;

    // अगर UPI है तो QR Code दिखाओ
    if (_selectedPaymentMethod == 'upi') {
      final String upiUrl =
          "upi://pay?pa=$_upiId&pn=गाँव की दुकान&am=${cartProvider.totalPrice.toStringAsFixed(0)}&cu=INR";
      await _showQrCodeDialog(upiUrl, cartProvider.totalPrice);
    }

    cartProvider.clearCart();

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // ✅ PAYMENT के बाद ही SHARE POPUP दिखाओ
    if (_selectedPaymentMethod == 'cod') {
      // COD के लिए सीधा Share Popup
      _showShareDialog();
    }
    // UPI के लिए QR Code बंद होने के बाद Share Popup दिखेगा
  }

  // ✅ QR Code Dialog - यहाँ कोई Share Popup नहीं
  Future<void> _showQrCodeDialog(String upiUrl, double amount) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'UPI QR Code स्कैन करें',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: QrImageView(
                  data: upiUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'कुल रकम: ₹${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 8),
              const Text('PhonePe, GooglePay या Paytm से स्कैन करें'),
              const SizedBox(height: 16),
              const Text(
                '✅ पेमेंट के बाद OK दबाएं',
                style: TextStyle(color: Colors.orange),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // ✅ QR Code बंद होने के बाद Share Popup दिखाओ
                  _showShareDialog();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('पेमेंट कर दिया ✅'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Share Dialog - सिर्फ Payment के बाद दिखेगा
  void _showShareDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ ऑर्डर हो गया!'),
        content: const Text('क्या आप इनवॉइस शेयर करना चाहते हैं?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(ctx); // Checkout screen बंद करो
            },
            child: const Text('बाद में'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_lastOrder != null) {
                Share.share(_generateInvoice(_lastOrder!));
              }
              Navigator.pop(ctx);
              Navigator.pop(ctx); // Checkout screen बंद करो
            },
            icon: const Icon(Icons.share),
            label: const Text('अभी शेयर करें'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  String _generateInvoice(Order order) {
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
