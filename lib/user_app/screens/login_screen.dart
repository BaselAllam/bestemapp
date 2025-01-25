import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/shared_widgets/txt_btn.dart';
import 'package:bestemapp/shared/shared_widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                LogoContainer(size: Size(MediaQuery.of(context).size.width / 2.5, 150)),
              ],
            ),
            Text('  ${selectedLang[AppLangAssets.login]}', style: AppFonts.hugeFontBlackColor),
            SizedBox(height: 30.0),
            authField(
              title: selectedLang[AppLangAssets.phoneNumber]!,
              inputTitle: selectedLang[AppLangAssets.enterUrPhoneNumber]!,
              inputStyle: AppFonts.subFontGreyColor,
              fillColor: AppColors.whiteColor,
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.number,
              controller: phoneController,
              formaters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            authField(
              title: selectedLang[AppLangAssets.password]!,
              inputTitle: selectedLang[AppLangAssets.enterUrPassword]!,
              inputStyle: AppFonts.subFontGreyColor,
              fillColor: AppColors.whiteColor,
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.text,
              controller: passwordController,
              formaters: [],
              obsecure: isSecure,
              suffix: ViewPasswordWidget(isSecure, () { isSecure = !isSecure; setState(() {});}),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TxtBtn(
                '${selectedLang[AppLangAssets.forgetPassword]!}         ',
                AppFonts.miniFontGreyColor,
                () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordPhoneOTPScreen()));
                }
              ),
            ),
            SizedBox(height: 45.0),
            Column(
              children: [
                CustomBtn(
                  widget: Text(selectedLang[AppLangAssets.login]!, style: AppFonts.subFontWhiteColor),
                  size: Size(MediaQuery.of(context).size.width / 1.15, 48),
                  color: AppColors.primaryColor,
                  radius: 12.0,
                  onPress: () async {
                    // await BlocProvider.of<UserCubit>(context).loginUser(emailController.text, passwordController.text);
                  }
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(color: AppColors.greyColor, endIndent: 20.0, indent: 20.0,),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedLang[AppLangAssets.dontHaveAccount]!, style: AppFonts.subFontGreyColor),
                  TxtBtn(
                    ' ${selectedLang[AppLangAssets.register]!}',
                    AppFonts.subFontPrimaryColor,
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                    }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}