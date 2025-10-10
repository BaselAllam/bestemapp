import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'category': 'Buying',
      'question': 'How do I purchase a car?',
      'answer': 'Browse our listings, select a car you\'re interested in, and click "Contact Seller" or "Buy Now" if available. You can schedule a test drive, inspect the vehicle, and complete the purchase through our secure platform or directly with the seller.',
    },
    {
      'category': 'Buying',
      'question': 'Can I test drive a car before buying?',
      'answer': 'Yes! Most sellers allow test drives. Contact the seller through our platform to schedule a convenient time. We recommend test driving any vehicle before making a purchase decision.',
    },
    {
      'category': 'Buying',
      'question': 'Are the cars inspected?',
      'answer': 'Certified dealers provide inspection reports. For private sellers, we recommend getting an independent pre-purchase inspection. You can also request vehicle history reports through our platform.',
    },
    {
      'category': 'Selling',
      'question': 'How do I list my car for sale?',
      'answer': 'Create an account, click "Sell Your Car," fill in the vehicle details, upload photos, set your price, and publish your listing. Basic listings are free, with premium options available for better visibility.',
    },
    {
      'category': 'Selling',
      'question': 'What documents do I need to sell my car?',
      'answer': 'You\'ll need the vehicle title, registration, service records, and a valid ID. Additional documents may be required depending on your location. We provide a checklist when you create your listing.',
    },
    {
      'category': 'Selling',
      'question': 'How long does it take to sell a car?',
      'answer': 'It varies based on price, condition, and demand. On average, cars sell within 2-4 weeks. Competitive pricing and quality photos can help sell faster.',
    },
    {
      'category': 'Payment',
      'question': 'What payment methods are accepted?',
      'answer': 'Payment methods vary by seller. Options include bank transfers, certified checks, financing through our partners, and cash. For high-value transactions, we recommend secure payment methods and meeting at banks.',
    },
    {
      'category': 'Payment',
      'question': 'Is financing available?',
      'answer': 'Yes! We partner with multiple lenders to offer competitive financing options. You can pre-qualify for a loan directly through our app without affecting your credit score.',
    },
    {
      'category': 'Account',
      'question': 'How do I create an account?',
      'answer': 'Click "Sign Up" in the app menu, enter your email and create a password, or sign up using Google/Apple. Verify your email to activate your account and start buying or selling.',
    },
    {
      'category': 'Account',
      'question': 'How do I reset my password?',
      'answer': 'Click "Forgot Password" on the login screen, enter your registered email, and follow the instructions sent to your inbox to reset your password.',
    },
    {
      'category': 'Safety',
      'question': 'How do I avoid scams?',
      'answer': 'Meet in public places, verify the seller\'s identity, inspect the vehicle in person, never wire money to unknown parties, and use secure payment methods. Report suspicious listings immediately.',
    },
    {
      'category': 'Safety',
      'question': 'What if I have an issue with a seller?',
      'answer': 'Contact our support team immediately through the app. We investigate all reports and take appropriate action. Keep all communication within our platform for your protection.',
    },
  ];

  List<Map<String, String>> get filteredFAQs {
    if (_searchQuery.isEmpty) return _faqs;
    return _faqs.where((faq) {
      return faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = filteredFAQs;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('FAQ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _expandedIndex = null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try different keywords',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final faq = filteredList[index];
                      final isExpanded = _expandedIndex == index;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedIndex = isExpanded ? null : index;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(faq['category']!),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        faq['category']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        faq['question']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  faq['answer']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  'Still have questions?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to contact support
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Contact Support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Buying':
        return Colors.blue[600]!;
      case 'Selling':
        return Colors.green[600]!;
      case 'Payment':
        return Colors.orange[600]!;
      case 'Account':
        return Colors.purple[600]!;
      case 'Safety':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}