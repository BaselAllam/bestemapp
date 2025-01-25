import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/filter_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class SearchResultScreen extends StatefulWidget {
  final String screenTitle;
  SearchResultScreen({required this.screenTitle});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(widget.screenTitle, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: Column(
        children: [
          SafeArea(
            top: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterWidget(icon: Icons.sort, txt: selectedLang[AppLangAssets.sort]!),
                FilterWidget(icon: Icons.tune, txt: selectedLang[AppLangAssets.filter]!),
                FilterWidget(icon: Icons.menu, txt: selectedLang[AppLangAssets.vechileCondition]!),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              children: [
                for (int i = 0; i < 10; i++)
                AdWidget(imgHieght: 280,)
              ]
            ),
          ),
        ],
      ),
    );
  }
}