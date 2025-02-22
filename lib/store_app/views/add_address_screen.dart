import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  TextEditingController addressTitleController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController flatNumberController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.addAddress]!, style: AppFonts.primaryFontBlackColor),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              authField(
                title: selectedLang[AppLangAssets.addressTitle]!,
                inputTitle: selectedLang[AppLangAssets.addressTitle]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: addressTitleController,
                formaters: []
              ),
              authField(
                title: selectedLang[AppLangAssets.apartmentNumber]!,
                inputTitle: selectedLang[AppLangAssets.apartmentNumber]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.number,
                controller: apartmentNumberController,
                formaters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              authField(
                title: selectedLang[AppLangAssets.flatNumber]!,
                inputTitle: selectedLang[AppLangAssets.flatNumber]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: flatNumberController,
                formaters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              authField(
                title: selectedLang[AppLangAssets.streetName]!,
                inputTitle: selectedLang[AppLangAssets.streetName]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: streetNameController,
                formaters: []
              ),
              authField(
                title: selectedLang[AppLangAssets.landMark]!,
                inputTitle: selectedLang[AppLangAssets.landMark]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: landMarkController,
                formaters: []
              ),
              SizedBox(height: 45.0),
              Column(
                children: [
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.addAddress]!, style: AppFonts.subFontWhiteColor),
                    size: Size(MediaQuery.of(context).size.width / 1.15, 48),
                    color: AppColors.primaryColor,
                    radius: 12.0,
                    onPress: () async {
                      
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}