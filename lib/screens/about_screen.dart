import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isAboutExpanded = false;
  bool _isPrivacyExpanded = false;
  bool _isTermsExpanded = false;

  final String _aboutText =
      "गाँव की दुकान एक डिजिटल पहल है जो गाँव के लोगों को आसानी से कृषि उत्पाद, बीज, खाद और अन्य आवश्यक सामान खरीदने की सुविधा देती है.\n\nहमारा उद्देश्य: गाँव के हर किसान और ग्राहक को सस्ती और सुलभ कीमत पर असली सामान उपलब्ध कराना.\n\n✅ 100% असली उत्पाद\n✅ फ्री डिलीवरी\n✅ UPI और कैश पेमेंट\n✅ 24x7 ग्राहक सहायता\n\nहमारी टीम हमेशा आपकी सेवा में तत्पर है। किसी भी समस्या के लिए हमसे संपर्क करें।";

  final String _privacyText =
      "हम आपकी निजी जानकारी को सुरक्षित रखते हैं.\n\nहम क्या जानकारी इकट्ठा करते हैं:\n• नाम और पता\n• मोबाइल नंबर\n• ऑर्डर हिस्ट्री\n• ऑर्डर के लिए आवश्यक जानकारी\n\nहम आपकी जानकारी का उपयोग कैसे करते हैं:\n• ऑर्डर प्रोसेस करने के लिए\n• डिलीवरी के लिए\n• आपसे संपर्क करने के लिए\n• सर्विस बेहतर बनाने के लिए\n\nहम आपकी जानकारी किसी तीसरे पक्ष के साथ साझा नहीं करते हैं।\n\nआपके अधिकार:\n• अपनी जानकारी देख सकते हैं\n• अपनी जानकारी सुधार सकते हैं\n• अपनी जानकारी हटा सकते हैं";

  final String _termsText =
      "📜 नियम और शर्तें\n\n1. सभी उत्पाद 100% असली हैं\n2. डिलीवरी फ्री है\n3. पेमेंट UPI या कैश से कर सकते हैं\n4. सामान मिलने के बाद ही पैसे दें\n5. 7 दिन में बदलने की सुविधा\n6. खराब सामान की तुरंत शिकायत करें\n7. ग्राहक सेवा हमेशा उपलब्ध है\n8. हमारी टीम आपकी मदद के लिए तैयार है\n\nधन्यवाद आपका विश्वास के लिए!";

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: Colors.green[50], borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Icon(Icons.store, size: 80, color: Colors.green[700]),
              const SizedBox(height: 16),
              const Text('गाँव की दुकान',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('आपका अपना गाँव का बाजार'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('👨‍🌾 दुकानदार की जानकारी',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, 'नाम', 'राम सिंह'),
                _buildInfoRow(Icons.phone, 'मोबाइल', '+91 98765 43210'),
                _buildInfoRow(Icons.payment, 'UPI ID', 'shopowner@okhdfcbank'),
                _buildInfoRow(
                    Icons.location_on, 'पता', 'गाँव की दुकान, मुख्य बाजार'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('⏰ दुकान का समय',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTimingRow('सोमवार - शनिवार', 'सुबह 8:00 - शाम 8:00'),
                _buildTimingRow('रविवार', 'सुबह 9:00 - शाम 6:00'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('📞 त्वरित संपर्क',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: _buildActionButton(Icons.call, 'कॉल',
                            () => _makePhoneCall('+919876543210'))),
                    Expanded(
                        child: _buildActionButton(Icons.message, 'WhatsApp',
                            () => _openWhatsApp('919876543210'))),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ✅ About Us - Full Text with Expand/Collapse
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('📝 हमारे बारे में',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isAboutExpanded
                      ? _aboutText
                      : _aboutText.substring(
                              0,
                              _aboutText.length > 150
                                  ? 150
                                  : _aboutText.length) +
                          (_aboutText.length > 150 ? '...' : ''),
                  style: const TextStyle(height: 1.5),
                ),
              ),
              if (_aboutText.length > 150)
                TextButton(
                  onPressed: () =>
                      setState(() => _isAboutExpanded = !_isAboutExpanded),
                  child:
                      Text(_isAboutExpanded ? 'छोटा करें ▲' : 'पूरा पढ़ें ▼'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // ✅ Privacy Policy - Full Text with Expand/Collapse
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('🔒 प्राइवेसी पॉलिसी',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isPrivacyExpanded
                      ? _privacyText
                      : _privacyText.substring(
                              0,
                              _privacyText.length > 150
                                  ? 150
                                  : _privacyText.length) +
                          (_privacyText.length > 150 ? '...' : ''),
                  style: const TextStyle(height: 1.5),
                ),
              ),
              if (_privacyText.length > 150)
                TextButton(
                  onPressed: () =>
                      setState(() => _isPrivacyExpanded = !_isPrivacyExpanded),
                  child:
                      Text(_isPrivacyExpanded ? 'छोटा करें ▲' : 'पूरा पढ़ें ▼'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // ✅ Terms & Conditions - Full Text with Expand/Collapse
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('📜 नियम और शर्तें',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isTermsExpanded
                      ? _termsText
                      : _termsText.substring(
                              0,
                              _termsText.length > 150
                                  ? 150
                                  : _termsText.length) +
                          (_termsText.length > 150 ? '...' : ''),
                  style: const TextStyle(height: 1.5),
                ),
              ),
              if (_termsText.length > 150)
                TextButton(
                  onPressed: () =>
                      setState(() => _isTermsExpanded = !_isTermsExpanded),
                  child:
                      Text(_isTermsExpanded ? 'छोटा करें ▲' : 'पूरा पढ़ें ▼'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          const SizedBox(width: 12),
          SizedBox(
              width: 70,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTimingRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(time, style: const TextStyle(fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12))
        ]),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    await launchUrl(Uri.parse("https://wa.me/$phoneNumber"));
  }
}
