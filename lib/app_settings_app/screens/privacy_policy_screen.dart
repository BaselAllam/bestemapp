import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSection(
            icon: Icons.info_outline,
            title: '1. Information We Collect',
            content: [
              _buildSubSection(
                'Personal Information',
                'When you create an account, we collect your name, email address, phone number, and location. For sellers, we may also collect payment information and identification documents.',
              ),
              _buildSubSection(
                'Vehicle Information',
                'When listing a car, we collect details including make, model, year, VIN, mileage, condition, and photos you upload.',
              ),
              _buildSubSection(
                'Usage Data',
                'We automatically collect information about your device, browsing actions, and patterns. This includes IP address, device type, operating system, and app usage statistics.',
              ),
              _buildSubSection(
                'Location Data',
                'With your permission, we collect location data to show nearby listings and improve search results.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.business_center,
            title: '2. How We Use Your Information',
            content: [
              _buildBulletPoint('To facilitate buying and selling of vehicles'),
              _buildBulletPoint('To verify user identity and prevent fraud'),
              _buildBulletPoint('To process payments and transactions'),
              _buildBulletPoint('To communicate about your listings and inquiries'),
              _buildBulletPoint('To send notifications about account activity'),
              _buildBulletPoint('To improve our services and user experience'),
              _buildBulletPoint('To provide customer support'),
              _buildBulletPoint('To comply with legal obligations'),
            ],
          ),
          _buildSection(
            icon: Icons.share,
            title: '3. Information Sharing',
            content: [
              _buildSubSection(
                'With Other Users',
                'When you list a vehicle or inquire about one, certain information (name, contact details, location) is shared with potential buyers or sellers.',
              ),
              _buildSubSection(
                'With Service Providers',
                'We share information with third-party service providers who help us operate our platform, including payment processors, hosting services, and analytics providers.',
              ),
              _buildSubSection(
                'For Legal Reasons',
                'We may disclose information when required by law, to protect our rights, prevent fraud, or ensure user safety.',
              ),
              _buildSubSection(
                'Business Transfers',
                'If we\'re involved in a merger, acquisition, or sale, your information may be transferred to the new entity.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.security,
            title: '4. Data Security',
            content: [
              _buildParagraph(
                'We implement industry-standard security measures to protect your personal information, including encryption, secure servers, and access controls. However, no method of transmission over the internet is 100% secure.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.cookie,
            title: '5. Cookies and Tracking',
            content: [
              _buildParagraph(
                'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and deliver personalized content. You can control cookie preferences through your device settings.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.account_circle,
            title: '6. Your Rights and Choices',
            content: [
              _buildBulletPoint('Access, update, or delete your personal information'),
              _buildBulletPoint('Opt-out of marketing communications'),
              _buildBulletPoint('Disable location services'),
              _buildBulletPoint('Request a copy of your data'),
              _buildBulletPoint('Object to data processing'),
              _buildBulletPoint('Delete your account at any time'),
            ],
          ),
          _buildSection(
            icon: Icons.child_care,
            title: '7. Children\'s Privacy',
            content: [
              _buildParagraph(
                'Our service is not intended for users under 18 years of age. We do not knowingly collect information from children. If you believe we have collected information from a child, please contact us immediately.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.storage,
            title: '8. Data Retention',
            content: [
              _buildParagraph(
                'We retain your information for as long as your account is active or as needed to provide services. After account deletion, we may retain certain information for legal compliance, dispute resolution, and fraud prevention.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.link,
            title: '9. Third-Party Links',
            content: [
              _buildParagraph(
                'Our app may contain links to third-party websites or services. We are not responsible for their privacy practices. We encourage you to review their privacy policies.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.update,
            title: '10. Changes to This Policy',
            content: [
              _buildParagraph(
                'We may update this Privacy Policy periodically. We will notify you of significant changes via email or app notification. Your continued use after changes constitutes acceptance of the updated policy.',
              ),
            ],
          ),
          _buildSection(
            icon: Icons.contact_mail,
            title: '11. Contact Us',
            content: [
              _buildParagraph(
                'If you have questions about this Privacy Policy or our data practices, please contact us:',
              ),
              const SizedBox(height: 8),
              _buildContactInfo('Email', 'privacy@carmarketplace.com', Icons.email),
              _buildContactInfo('Phone', '+1 (555) 123-4567', Icons.phone),
              _buildContactInfo('Address', '123 Market Street, Suite 100\nSan Francisco, CA 94103', Icons.location_on),
            ],
          ),
          const SizedBox(height: 16),
          _buildFooter(),
          const SizedBox(height: 24),
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
          const Icon(Icons.privacy_tip, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Your Privacy Matters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: October 10, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This Privacy Policy explains how we collect, use, share, and protect your personal information when you use our car marketplace platform.',
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
            'Your trust is important to us',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'We are committed to protecting your privacy and maintaining the security of your personal information.',
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