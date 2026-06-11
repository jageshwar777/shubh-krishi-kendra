import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';
import 'screens/product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import 'screens/about_screen.dart';
import 'screens/admin_screen.dart';
import 'utils/web_storage_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WebStorageHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'गाँव की दुकान',
        theme: ThemeData(
          primaryColor: Colors.green[700],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _shopName = 'गाँव की दुकान';

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductScreen(),
    const CartScreen(),
    const OrderScreen(),
    const AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadShopName();
  }

  Future<void> _loadShopName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _shopName = prefs.getString('shop_name') ?? 'गाँव की दुकान';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading shop name: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_shopName),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onLongPress: () => _showAdminLogin(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.admin_panel_settings),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'होम'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'प्रोडक्ट'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'कार्ट'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'ऑर्डर'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'जानकारी'),
        ],
      ),
    );
  }

  void _showAdminLogin(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('दुकानदार लॉगिन'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'ईमेल', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'पासवर्ड', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('रद्द करें')),
            ElevatedButton(
              onPressed: () async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final savedPassword =
                      prefs.getString('admin_password') ?? 'admin123';
                  final savedEmail =
                      prefs.getString('admin_email') ?? 'admin@shop.com';

                  if (emailController.text == savedEmail &&
                      passwordController.text == savedPassword) {
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                    }
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminScreen()),
                      );
                    }
                  } else {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                            content: Text('गलत ईमेल या पासवर्ड'),
                            backgroundColor: Colors.red),
                      );
                    }
                  }
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                          content: Text('लॉगिन error: $e'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('लॉगिन'),
            ),
          ],
        );
      },
    );
  }
}
