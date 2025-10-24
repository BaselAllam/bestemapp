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
                  title: selectedLang[AppLangAssets.acceptanceOfTerms]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.acceptanceOfTermsBody]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.person_outline,
                  title: selectedLang[AppLangAssets.userResponsibility]!,
                  content: [
                    _buildSubSection(
                      selectedLang[AppLangAssets.userResponsibilityBody1]!,
                      selectedLang[AppLangAssets.userResponsibilityBody2]!,
                    ),
                    _buildSubSection(
                      selectedLang[AppLangAssets.userResponsibilityBody3]!,
                      selectedLang[AppLangAssets.userResponsibilityBody4]!,
                    ),
                    _buildSubSection(
                      selectedLang[AppLangAssets.userResponsibilityBody5]!,
                      selectedLang[AppLangAssets.userResponsibilityBody6]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.directions_car,
                  title: selectedLang[AppLangAssets.vehicleListing]!,
                  content: [
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody1]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody2]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody3]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody4]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody5]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.vehicleListingBody6]!),
                  ],
                ),
                _buildSection(
                  icon: Icons.swap_horiz,
                  title: selectedLang[AppLangAssets.transactions]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.transactionsBody]!,
                    ),
                    const SizedBox(height: 12),
                    _buildSubSection(
                      selectedLang[AppLangAssets.transactionsBodyTitle1]!,
                      selectedLang[AppLangAssets.transactionsBodySubTitle1]!,
                    ),
                    _buildSubSection(
                      selectedLang[AppLangAssets.transactionsBodyTitle2]!,
                      selectedLang[AppLangAssets.transactionsBodySubTitle2]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.payments,
                  title: selectedLang[AppLangAssets.paymentFee]!,
                  content: [
                    _buildBulletPoint(selectedLang[AppLangAssets.paymentFeeBody1]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.paymentFeeBody2]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.paymentFeeBody3]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.paymentFeeBody4]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.paymentFeeBody5]!),
                  ],
                ),
                _buildSection(
                  icon: Icons.block,
                  title: selectedLang[AppLangAssets.prohibtedActivities]!,
                  content: [
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody1]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody2]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody3]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody4]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody5]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody6]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.prohibtedActivitiesBody7]!),
                  ],
                ),
                _buildSection(
                  icon: Icons.shield,
                  title: selectedLang[AppLangAssets.intellectualPropery]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.intellectualProperyBody]!,
                    ),
                    const SizedBox(height: 12),
                    _buildSubSection(
                      selectedLang[AppLangAssets.intellectualProperyBody1]!,
                      selectedLang[AppLangAssets.intellectualProperyBody2]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.gavel,
                  title: selectedLang[AppLangAssets.liabilityLimitations]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.liabilityLimitationsBody]!,
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(selectedLang[AppLangAssets.liabilityLimitationsBody1]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.liabilityLimitationsBody2]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.liabilityLimitationsBody3]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.liabilityLimitationsBody4]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.liabilityLimitationsBody5]!),
                  ],
                ),
                _buildSection(
                  icon: Icons.balance,
                  title: selectedLang[AppLangAssets.disputeResolution]!,
                  content: [
                    _buildSubSection(
                      selectedLang[AppLangAssets.disputeResolutionBody]!,
                      selectedLang[AppLangAssets.disputeResolutionBody2]!,
                    ),
                    _buildSubSection(
                      selectedLang[AppLangAssets.disputeResolutionBody3]!,
                      selectedLang[AppLangAssets.disputeResolutionBody4]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.cancel,
                  title: selectedLang[AppLangAssets.accountTermination]!,
                  content: [
                    _buildBulletPoint(selectedLang[AppLangAssets.accountTerminationBody1]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.accountTerminationBody2]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.accountTerminationBody3]!),
                    _buildBulletPoint(selectedLang[AppLangAssets.accountTerminationBody4]!),
                  ],
                ),
                _buildSection(
                  icon: Icons.update,
                  title: selectedLang[AppLangAssets.changesToTerms]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.changesToTermsBody]!,
                    ),
                  ],
                ),
                _buildSection(
                  icon: Icons.contact_support,
                  title: selectedLang[AppLangAssets.contactUsTitle]!,
                  content: [
                    _buildParagraph(
                      selectedLang[AppLangAssets.termsContactSubTitle]!,
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo(selectedLang[AppLangAssets.email]!, 'info@bestem.app', Icons.email),
                    _buildContactInfo(selectedLang[AppLangAssets.addressTitle]!, 'Shorouk City, Cairo, EG 11837', Icons.location_on),
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
            '${selectedLang[AppLangAssets.lastUpdated]} October 12, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            selectedLang[AppLangAssets.plzReadTerms]!,
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
          Text(
            selectedLang[AppLangAssets.termsHeaderTitle]!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            selectedLang[AppLangAssets.termsHeaderSubTitle]!,
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