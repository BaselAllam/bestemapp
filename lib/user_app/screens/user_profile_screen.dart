import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/shared_widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isSecure = true;
  String gender = selectedLang[AppLangAssets.male]!;

  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(selectedLang[AppLangAssets.myProfile]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 150,
                    width: 150,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://avatars.githubusercontent.com/u/44323531?v=4'),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.circle
                    ),
                  ),
                ),
              ],
            ),
            authField(
              title: selectedLang[AppLangAssets.fullName]!,
              controller: userNameController,
              textInputAction: TextInputAction.done,
              enabled: isEditable,
              keyBoardType: TextInputType.text,
              validatorMethod: (v) {},
              formaters: [],
              inputStyle: AppFonts.subFontGreyColor,
              fillColor: AppColors.whiteColor,
              inputTitle: selectedLang[AppLangAssets.fullName]!
            ),
            authField(
              title: selectedLang[AppLangAssets.phoneNumber]!,
              controller: phoneController,
              textInputAction: TextInputAction.done,
              enabled: isEditable,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              keyBoardType: TextInputType.number,
              inputStyle: AppFonts.subFontGreyColor,
              fillColor: AppColors.whiteColor,
              inputTitle: selectedLang[AppLangAssets.phoneNumber]!
            ),
            authField(
              title: selectedLang[AppLangAssets.password]!,
              controller: passwordController,
              textInputAction: TextInputAction.done,
              enabled: isEditable,
              obsecure: isSecure,
              suffix: ViewPasswordWidget(isSecure, () {
                isSecure = !isSecure;
                setState(() {});
              }),
              validatorMethod: (v) {},
              keyBoardType: TextInputType.text,
              inputStyle: AppFonts.subFontGreyColor,
              fillColor: AppColors.whiteColor,
              formaters: [],
              inputTitle: selectedLang[AppLangAssets.password]!
            ),
            SizedBox(height: 15.0),
            ListTile(
              title: Text(selectedLang[AppLangAssets.gender]!, style: AppFonts.primaryFontBlackColor),
              subtitle: Text(gender, style: AppFonts.subFontGreenColor),
              trailing: PopupMenuButton(
                icon: Icon(Icons.arrow_downward, color: AppColors.primaryColor, size: 20.0),
                onSelected: (value) {
                  gender = value;
                  setState(() {});
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: Text(selectedLang[AppLangAssets.male]!, style: AppFonts.subFontBlackColor),
                      value: selectedLang[AppLangAssets.male]!,
                    ),
                    PopupMenuItem(
                      child: Text(selectedLang[AppLangAssets.male]!, style: AppFonts.subFontBlackColor),
                      value: selectedLang[AppLangAssets.male]!,
                    ),
                  ];
                },
              ),
            ),
            Column(
              children: [
                TextButton(
                  child: Text(isEditable ? selectedLang[AppLangAssets.save]! : selectedLang[AppLangAssets.edit]!, style: AppFonts.primaryFontWhiteColor),
                  style: TextButton.styleFrom(
                    backgroundColor: isEditable ? AppColors.primaryColor : AppColors.greyColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    fixedSize: Size(200, 50)
                  ),
                  onPressed: () {
                    isEditable = !isEditable;
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}