import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(selectedLang[AppLangAssets.termAndConditions]!, style: TextStyle(fontWeight: FontWeight.bold)),
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSection(
                  icon: Icons.handshake,
                  title: '1. Acceptance of Terms',
                  content: [
                    _buildParagraph(
                      'By accessing and using this car marketplace application, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use this service.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.person_outline,
                  title: '2. User Responsibilities',
                  content: [
                    _buildSubSection(
                      'Account Security',
                      'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                    ),
                    _buildSubSection(
                      'Accurate Information',
                      'Users must provide truthful and accurate information when creating accounts or listing vehicles. Any false information may result in account suspension.',
                    ),
                    _buildSubSection(
                      'Legal Compliance',
                      'You agree to comply with all applicable local, state, and federal laws when using our platform.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.directions_car,
                  title: '3. Vehicle Listings',
                  content: [
                    _buildBulletPoint('All vehicle information must be accurate and truthful'),
                    _buildBulletPoint('Photos must represent the actual condition of the vehicle'),
                    _buildBulletPoint('Mileage, accident history, and defects must be disclosed'),
                    _buildBulletPoint('Misleading or fraudulent listings are strictly prohibited'),
                    _buildBulletPoint('Sellers must have legal ownership or authorization to sell'),
                    _buildBulletPoint('Listings violating these terms may be removed without notice'),
                  ],
                ),
                _buildSection(
                  icon: Icons.swap_horiz,
                  title: '4. Transactions',
                  content: [
                    _buildParagraph(
                      'All transactions between buyers and sellers are conducted at their own risk. Our platform facilitates connections but is not a party to the actual sale, transfer, or condition of vehicles.',
                    ),
                    const SizedBox(height: 12),
                    _buildSubSection(
                      'Buyer Responsibilities',
                      'Buyers should inspect vehicles, verify documentation, and conduct due diligence before purchase.',
                    ),
                    _buildSubSection(
                      'Seller Responsibilities',
                      'Sellers must provide clear title, accurate documentation, and honest disclosure of vehicle condition.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.payments,
                  title: '5. Payment and Fees',
                  content: [
                    _buildBulletPoint('Service fees may apply for premium listings or featured placements'),
                    _buildBulletPoint('All fees are clearly communicated before charges are made'),
                    _buildBulletPoint('Payments are processed through secure, authorized gateways'),
                    _buildBulletPoint('Refund policies are outlined in our refund terms'),
                    _buildBulletPoint('Transaction fees between buyers and sellers are separate'),
                  ],
                ),
                _buildSection(
                  icon: Icons.block,
                  title: '6. Prohibited Activities',
                  content: [
                    _buildBulletPoint('Posting fraudulent or stolen vehicles'),
                    _buildBulletPoint('Manipulating listings or reviews'),
                    _buildBulletPoint('Harassing or threatening other users'),
                    _buildBulletPoint('Using the platform for illegal purposes'),
                    _buildBulletPoint('Creating multiple accounts to circumvent restrictions'),
                    _buildBulletPoint('Scraping or mining data without authorization'),
                    _buildBulletPoint('Impersonating other users or entities'),
                  ],
                ),
                _buildSection(
                  icon: Icons.shield,
                  title: '7. Intellectual Property',
                  content: [
                    _buildParagraph(
                      'All content on the platform, including logos, designs, text, and graphics, is owned by us or our licensors. Users may not reproduce, distribute, or create derivative works without permission.',
                    ),
                    const SizedBox(height: 12),
                    _buildSubSection(
                      'User Content',
                      'By posting content, you grant us a non-exclusive license to use, display, and distribute your content on our platform.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.gavel,
                  title: '8. Liability Limitations',
                  content: [
                    _buildParagraph(
                      'The platform is provided "as is" without warranties of any kind. We are not liable for:',
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Disputes between buyers and sellers'),
                    _buildBulletPoint('Vehicle defects, accidents, or mechanical issues'),
                    _buildBulletPoint('Fraudulent transactions or misrepresentations'),
                    _buildBulletPoint('Loss of data or service interruptions'),
                    _buildBulletPoint('Indirect, incidental, or consequential damages'),
                  ],
                ),
                _buildSection(
                  icon: Icons.balance,
                  title: '9. Dispute Resolution',
                  content: [
                    _buildSubSection(
                      'Mediation',
                      'Users agree to attempt resolution through mediation before pursuing legal action. We provide support for resolving conflicts but are not party to transactions.',
                    ),
                    _buildSubSection(
                      'Arbitration',
                      'Any disputes that cannot be resolved through mediation will be settled through binding arbitration in accordance with applicable laws.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.cancel,
                  title: '10. Account Termination',
                  content: [
                    _buildBulletPoint('We reserve the right to suspend or terminate accounts violating these terms'),
                    _buildBulletPoint('Users may close their accounts at any time through settings'),
                    _buildBulletPoint('Upon termination, active listings will be removed'),
                    _buildBulletPoint('Some data may be retained for legal compliance'),
                  ],
                ),
                _buildSection(
                  icon: Icons.update,
                  title: '11. Changes to Terms',
                  content: [
                    _buildParagraph(
                      'We may update these terms periodically. Users will be notified of significant changes via email or app notification. Continued use after changes constitutes acceptance of the revised terms.',
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.contact_support,
                  title: '12. Contact Information',
                  content: [
                    _buildParagraph(
                      'For questions or concerns about these terms, please contact us:',
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo('Email', 'support@carmarketplace.com', Icons.email),
                    _buildContactInfo('Phone', '+1 (555) 123-4567', Icons.phone),
                    _buildContactInfo('Address', '123 Market Street, Suite 100\nSan Francisco, CA 94103', Icons.location_on),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFooter(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.description, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            selectedLang[AppLangAssets.termAndConditions]!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: October 12, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please read these terms carefully before using our car marketplace platform. By using our services, you agree to these terms and conditions.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue[700], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        height: 1.5,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
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
  }

  Widget _buildContactInfo(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.verified_user, color: Colors.blue[700], size: 32),
          const SizedBox(height: 8),
          const Text(
            'Safe & Transparent Marketplace',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'These terms ensure a fair and secure environment for all users buying and selling vehicles on our platform.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

}