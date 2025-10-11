import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:bestemapp/user_app/widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isSecure = true;

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
      body: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetUserDataLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserDataErrorState || state is GetUserDataSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else {
            var userModel = BlocProvider.of<UserCubit>(context).userModel;
            return Padding(
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
                              image: userModel!.profilePic.isEmpty ? AssetImage(AppAssets.noPPIcon) : NetworkImage(userModel.profilePic),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ],
                  ),
                  authField(
                    title: selectedLang[AppLangAssets.firstName]!,
                    controller: firstNameController,
                    textInputAction: TextInputAction.done,
                    enabled: isEditable,
                    keyBoardType: TextInputType.text,
                    validatorMethod: (v) {},
                    formaters: [],
                    inputStyle: AppFonts.subFontGreyColor,
                    fillColor: AppColors.whiteColor,
                    inputTitle: selectedLang[AppLangAssets.firstName]!
                  ),
                  authField(
                    title: selectedLang[AppLangAssets.lastName]!,
                    controller: lastNameController,
                    textInputAction: TextInputAction.done,
                    enabled: isEditable,
                    keyBoardType: TextInputType.text,
                    validatorMethod: (v) {},
                    formaters: [],
                    inputStyle: AppFonts.subFontGreyColor,
                    fillColor: AppColors.whiteColor,
                    inputTitle: selectedLang[AppLangAssets.lastName]!
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
                    title: selectedLang[AppLangAssets.email]!,
                    controller: emailController,
                    textInputAction: TextInputAction.done,
                    enabled: isEditable,
                    formaters: [],
                    keyBoardType: TextInputType.emailAddress,
                    inputStyle: AppFonts.subFontGreyColor,
                    fillColor: AppColors.whiteColor,
                    inputTitle: selectedLang[AppLangAssets.email]!
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
            );
          }
        }
      ),
    );
  }
}