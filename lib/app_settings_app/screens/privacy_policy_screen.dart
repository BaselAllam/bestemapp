import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/shared/utils/privacy_policy.dart';
import 'package:flutter/material.dart';


class PrivacyPolicySreen extends StatefulWidget {
  const PrivacyPolicySreen({super.key});

  @override
  State<PrivacyPolicySreen> createState() => _PrivacyPolicySreenState();
}

class _PrivacyPolicySreenState extends State<PrivacyPolicySreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.ofWhiteColor,
        elevation: 0.0,
        title: Text(selectedLang[AppLangAssets.privacyPolicy]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(selectedLang[AppLangAssets.privacyPolicy]!, style: AppFonts.subFontBlackColor),
              subtitle: Text(cancelationPolicy, style: AppFonts.subFontGreyColor),
            ),
            ListTile(
              title: Text(selectedLang[AppLangAssets.termAndConditions]!, style: AppFonts.subFontBlackColor),
              subtitle: Text(termsAndConditions, style: AppFonts.subFontGreyColor),
            ),
          ],
        ),
      ),
    );
  }
}