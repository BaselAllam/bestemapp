import 'package:bestemapp/ads_app/logic/ads_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/ads_app/widgets/ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
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

  bool isNewCondition = false;
  bool isUsedCondition = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(widget.screenTitle, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
        bottom: PreferredSize(
        preferredSize: Size(0.00, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilterWidget(
                icon: Icons.sort,
                txt: selectedLang[AppLangAssets.sort]!,
                onTap: () {
                  buildSortDialog();
                },
              ),
              FilterWidget(
                icon: Icons.tune,
                txt: selectedLang[AppLangAssets.filter]!,
                onTap: () {},
              ),
              FilterWidget(
                icon: Icons.menu,
                txt: selectedLang[AppLangAssets.vechileCondition]!,
                onTap: () {
                  buildConditionDialog();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ListView(
          children: [
            for (int i = 0; i < 10; i++)
            AdWidget(imgHieght: 250,)
          ]
        ),
      ),
    );
  }

  buildSortDialog() {
    return bottomSheet(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(selectedLang[AppLangAssets.sort]!, style: AppFonts.primaryFontBlackColor, textAlign: TextAlign.center),
            for (int i = 0; i < sortData.length; i++)
            ListTile(
              title: Text(sortData[i]['title'], style: AppFonts.subFontBlackColor),
              trailing: Checkbox(
                value: sortData[i]['value'],
                activeColor: AppColors.primaryColor,
                checkColor: AppColors.whiteColor,
                hoverColor: AppColors.primaryColor,
                onChanged: (v) {
                  sortData[i]['value'] = v;
                  for (var x in sortData) {
                    if (x['title'] != sortData[i]['title']) {
                      x['value'] = false;
                    }
                  }
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
      minHeight: 300,
      maxHeight: 300
    );
  }

  buildConditionDialog() {
    return bottomSheet(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(selectedLang[AppLangAssets.vechileCondition]!, style: AppFonts.primaryFontBlackColor, textAlign: TextAlign.center),
            ListTile(
              title: Text(selectedLang[AppLangAssets.newCondition]!, style: AppFonts.subFontBlackColor),
              trailing: Checkbox(
                value: isNewCondition,
                activeColor: AppColors.primaryColor,
                checkColor: AppColors.whiteColor,
                hoverColor: AppColors.primaryColor,
                onChanged: (v) {
                  isNewCondition = v!;
                  isUsedCondition = !v;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(selectedLang[AppLangAssets.usedCondition]!, style: AppFonts.subFontBlackColor),
              trailing: Checkbox(
                value: isUsedCondition,
                activeColor: AppColors.primaryColor,
                checkColor: AppColors.whiteColor,
                hoverColor: AppColors.primaryColor,
                onChanged: (v) {
                  isUsedCondition = v!;
                  isNewCondition = !v;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      minHeight: 200,
      maxHeight: 200
    );
  }
}