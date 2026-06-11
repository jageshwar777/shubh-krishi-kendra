import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // News Ticker
          Container(
            color: Colors.orange[100],
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Center(
                    child: Text(
                      '🎉 विशेष ऑफर: खाद पर 10% छूट! 🎉 | नए बीज आए | फ्री डिलीवरी',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Banner Slider
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.grass
                              : (index == 1
                                  ? Icons.agriculture
                                  : Icons.bug_report),
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          index == 0
                              ? '🌾 नए बीज आए'
                              : (index == 1
                                  ? '🧪 खाद पर छूट'
                                  : '🚜 कीटनाशक ऑफर'),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Features Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌟 हमारी विशेषताएं',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildFeatureCard(Icons.verified, '100% असली',
                            'उत्पाद', Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildFeatureCard(Icons.local_shipping,
                            'फ्री डिलीवरी', 'गाँव में', Colors.blue)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildFeatureCard(Icons.payment, 'UPI & कैश',
                            'पेमेंट', Colors.orange)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildFeatureCard(Icons.support_agent, '24x7',
                            'सहायता', Colors.purple)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
