import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddToWalletScreen extends StatefulWidget {
  const AddToWalletScreen({super.key});

  @override
  State<AddToWalletScreen> createState() => _AddToWalletScreenState();
}

class _AddToWalletScreenState extends State<AddToWalletScreen> {

  TextEditingController amountController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: BackBtn(),
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        title: Text(selectedLang[AppLangAssets.addToYourWallet]!, style: AppFonts.primaryFontBlackColor),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              authField(
                title: selectedLang[AppLangAssets.amount]!,
                inputTitle: '500',
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.number,
                controller: cardNumberController,
                formaters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              authField(
                title: selectedLang[AppLangAssets.cardNumber]!,
                inputTitle: 'xxxx xxxx xxxx xxxx',
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.number,
                controller: cardNumberController,
                formaters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              authField(
                title: selectedLang[AppLangAssets.cardHolderName]!,
                inputTitle: selectedLang[AppLangAssets.cardHolderName]!,
                inputStyle: AppFonts.subFontGreyColor,
                fillColor: AppColors.whiteColor,
                textInputAction: TextInputAction.done,
                keyBoardType: TextInputType.text,
                controller: cardHolderNameController,
                formaters: [],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: authField(
                      title: selectedLang[AppLangAssets.cvv]!,
                      inputTitle: selectedLang[AppLangAssets.cvv]!,
                      inputStyle: AppFonts.subFontGreyColor,
                      fillColor: AppColors.whiteColor,
                      textInputAction: TextInputAction.done,
                      keyBoardType: TextInputType.number,
                      controller: cvvController,
                      formaters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: authField(
                      title: selectedLang[AppLangAssets.expirationDate]!,
                      inputTitle: '24/12',
                      inputStyle: AppFonts.subFontGreyColor,
                      fillColor: AppColors.whiteColor,
                      textInputAction: TextInputAction.done,
                      keyBoardType: TextInputType.number,
                      controller: expiryController,
                      formaters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45.0),
              Column(
                children: [
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.addToWallet]!, style: AppFonts.subFontWhiteColor),
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