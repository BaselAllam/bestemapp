import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(selectedLang[AppLangAssets.privacyPolicy]!, style: TextStyle(fontWeight: FontWeight.bold)),
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
            title: selectedLang[AppLangAssets.informationWeCollect]!,
            content: [
              _buildSubSection(
                selectedLang[AppLangAssets.informationWeCollectTitle1]!,
                selectedLang[AppLangAssets.informationWeCollectSubTitle1]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationWeCollectTitle2]!,
                selectedLang[AppLangAssets.informationWeCollectSubTitle2]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationWeCollectTitle3]!,
                selectedLang[AppLangAssets.informationWeCollectSubTitle3]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationWeCollectTitle4]!,
                selectedLang[AppLangAssets.informationWeCollectSubTitle4]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.business_center,
            title: selectedLang[AppLangAssets.howWeUseUrInfo]!,
            content: [
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo1]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo2]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo3]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo4]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo5]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo6]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo7]!),
              _buildBulletPoint(selectedLang[AppLangAssets.howWeUseUrInfo8]!),
            ],
          ),
          _buildSection(
            icon: Icons.share,
            title: selectedLang[AppLangAssets.informationSharing]!,
            content: [
              _buildSubSection(
                selectedLang[AppLangAssets.informationSharingTitle1]!,
                selectedLang[AppLangAssets.informationSharingSubTitle1]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationSharingTitle2]!,
                selectedLang[AppLangAssets.informationSharingSubTitle2]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationSharingTitle3]!,
                selectedLang[AppLangAssets.informationSharingSubTitle3]!,
              ),
              _buildSubSection(
                selectedLang[AppLangAssets.informationSharingTitle4]!,
                selectedLang[AppLangAssets.informationSharingSubTitle4]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.security,
            title: selectedLang[AppLangAssets.dataSecurity]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.dataSecuritySubtitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.cookie,
            title: selectedLang[AppLangAssets.cookiesAndTracking]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.cookiesAndTrackingSubTitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.account_circle,
            title: selectedLang[AppLangAssets.yourRightsAndChoices]!,
            content: [
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices1]!),
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices2]!),
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices3]!),
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices4]!),
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices5]!),
              _buildBulletPoint(selectedLang[AppLangAssets.yourRightsAndChoices6]!),
            ],
          ),
          _buildSection(
            icon: Icons.child_care,
            title: selectedLang[AppLangAssets.childrenPolicyTitle]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.childrenPolicySubTitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.storage,
            title: selectedLang[AppLangAssets.dataRetentionTitle]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.dataRetentionSubTitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.link,
            title: selectedLang[AppLangAssets.thirdPartyLinksTitle]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.thirdPartyLinksSubTitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.update,
            title: selectedLang[AppLangAssets.changesToThisPolicyTitle]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.changesToThisPolicySubTitle]!,
              ),
            ],
          ),
          _buildSection(
            icon: Icons.contact_mail,
            title: selectedLang[AppLangAssets.contactUsTitle]!,
            content: [
              _buildParagraph(
                selectedLang[AppLangAssets.changesToThisPolicySubTitle]!,
              ),
              const SizedBox(height: 8),
              _buildContactInfo(selectedLang[AppLangAssets.email]!, 'info@bestem.app', Icons.email),
              _buildContactInfo(selectedLang[AppLangAssets.addressTitle]!, 'Shorouk City, Cairo, EG 11837', Icons.location_on),
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
          Text(
            selectedLang[AppLangAssets.urPrivacyMatters]!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${selectedLang[AppLangAssets.lastUpdated]} October 10, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            selectedLang[AppLangAssets.privacyHeaderBody]!,
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
            selectedLang[AppLangAssets.yourTrustIsImportant]!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            selectedLang[AppLangAssets.yourTrustIsImportantSubTitle]!,
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