import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ProfileDataSecreen extends StatefulWidget {
  const ProfileDataSecreen({super.key});

  @override
  State<ProfileDataSecreen> createState() => _ProfileDataSecreenState();
}

class _ProfileDataSecreenState extends State<ProfileDataSecreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.0)
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          authField(
            title: selectedLang[AppLangAssets.fullName]!,
            inputTitle: selectedLang[AppLangAssets.enterFullName]!,
            inputStyle: AppFonts.subFontGreyColor,
            fillColor: AppColors.whiteColor,
            textInputAction: TextInputAction.done,
            keyBoardType: TextInputType.text,
            controller: fullNameController,
            formaters: [],
          ),
          authField(
            title: selectedLang[AppLangAssets.phoneNumber]!,
            inputTitle: selectedLang[AppLangAssets.enterUrPhoneNumber]!,
            inputStyle: AppFonts.subFontGreyColor,
            fillColor: AppColors.whiteColor,
            textInputAction: TextInputAction.done,
            keyBoardType: TextInputType.number,
            controller: fullNameController,
            formaters: [
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ],
      ),
    );
  }
}