import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/shared/utils/privacy_policy.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.ofWhiteColor,
        elevation: 0.0,
        title: Text(selectedLang[AppLangAssets.aboutUs]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(selectedLang[AppLangAssets.aboutUs]!, style: AppFonts.subFontBlackColor),
              subtitle: Text(cancelationPolicy, style: AppFonts.subFontGreyColor),
            ),
            ListTile(
              title: Text(selectedLang[AppLangAssets.visionAndMission]!, style: AppFonts.subFontBlackColor),
              subtitle: Text(termsAndConditions, style: AppFonts.subFontGreyColor),
            ),
          ],
        ),
      ),
    );
  }
}