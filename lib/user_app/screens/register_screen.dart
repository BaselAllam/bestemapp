import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/field.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/shared_widgets/snack_widget.dart';
import 'package:bestemapp/shared/shared_widgets/view_password_widget.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackBtn(),
      ),
      body: BuildRegister(),
      // body: BlocBuilder<UserCubit, UserStates>(
      //   builder: (context, state) {
      //     if (BlocProvider.of<UserCubit>(context).registerCurrentStep == 0) {
      //       return BuildRegister();
      //     } else if (BlocProvider.of<UserCubit>(context).registerCurrentStep == 1) {
      //       return BuildVerifyPhone();
      //     } else {
      //       return SizedBox();
      //     }
      //   },
      // )
    );
  }
}


class BuildRegister extends StatefulWidget {
  const BuildRegister({super.key});

  @override
  State<BuildRegister> createState() => _BuildRegisterState();
}

class _BuildRegisterState extends State<BuildRegister> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String selectedCountry = 'EG';

  bool isSecure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: [
          Column(
            children: [
              LogoContainer(size: Size(MediaQuery.of(context).size.width / 2.5, 150)),
            ],
          ),
          Text('  ${selectedLang[AppLangAssets.register]!}', style: AppFonts.hugeFontBlackColor),
          SizedBox(height: 30.0),
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
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(selectedLang[AppLangAssets.phoneNumber]!, style: AppFonts.primaryFontBlackColor),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 13.0, right: 20.0),
            child: Row(
              children: [
                // PopupMenuButton(
                //   color: AppColors.whiteColor,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(color: AppColors.greyColor, width: 0.5),
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(14),
                //     child: Text(countryData[selectedCountry]!['countryFlag']!, style: AppFonts.secondaryBlackFont)
                //   ),
                //   itemBuilder: (context) {
                //     return <PopupMenuEntry<String>>[
                //       for (String i in countryData.keys)
                //       PopupMenuItem(
                //         child: Text('${countryData[i]!['countryFlag']}   ${countryData[i]!['countryName']} ${countryData[i]!['countryCode']}', style: AppFonts.miniBlackFont),
                //         value: i,
                //       ),
                //     ];
                //   },
                //   onSelected: (v) {
                //     setState(() {
                //       selectedCountry = v;
                //     });
                //   },
                // ),
                Expanded(
                  child: customField(
                    inputTitle: selectedLang[AppLangAssets.enterUrPhoneNumber]!,
                    inputStyle: AppFonts.subFontGreyColor,
                    fillColor: AppColors.whiteColor,
                    textInputAction: TextInputAction.done,
                    keyBoardType: TextInputType.number,
                    controller: numberController,
                    formaters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
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
            suffix: ViewPasswordWidget(isSecure, () { isSecure = !isSecure; setState(() {});})
          ),
          authField(
            title: selectedLang[AppLangAssets.confirmPassword]!,
            inputTitle: selectedLang[AppLangAssets.confirmPassword]!,
            inputStyle: AppFonts.subFontGreyColor,
            fillColor: AppColors.whiteColor,
            textInputAction: TextInputAction.done,
            keyBoardType: TextInputType.text,
            controller: confirmPasswordController,
            formaters: [],
            obsecure: isSecure
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              CustomBtn(
                widget: Text(selectedLang[AppLangAssets.register]!, style: AppFonts.subFontWhiteColor),
                size: Size(MediaQuery.of(context).size.width / 1.15, 48),
                color: AppColors.primaryColor,
                radius: 12.0,
                onPress: () async {
                  if (passwordController.text.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(snack(selectedLang[AppLangAssets.passwordLegnthError]!, AppColors.redColor));
                  } else if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(snack(selectedLang[AppLangAssets.passwordNotMatch]!, AppColors.redColor));
                  } else if (fullNameController.text.isEmpty || numberController.text.isEmpty || companyController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(snack(selectedLang[AppLangAssets.fieldsRequired]!, AppColors.redColor));
                  } else {
                    // await BlocProvider.of<UserCubit>(context).registerUser(fullName: fullNameController.text, number: '${countryData[selectedCountry]!['countryCode']!}${numberController.text}', email: emailController.text, company: companyController.text,
                    // password: passwordController.text, confirmPassword: confirmPasswordController.text, jobTitle: jobTitleController.text, experience: int.parse(experienceController.text), userType: selectedUserType
                    // );
                  }
                }
              ),
            ],
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}



// class BuildVerifyPhone extends StatefulWidget {
//   const BuildVerifyPhone({super.key});

//   @override
//   State<BuildVerifyPhone> createState() => _BuildVerifyPhoneState();
// }

// class _BuildVerifyPhoneState extends State<BuildVerifyPhone> {

//   List<TextEditingController> _controllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

//   @override
//   void initState() {
//     BlocProvider.of<UserCubit>(context).requestPhoneOtp(BlocProvider.of<UserCubit>(context).registeredPhoneNumber);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(10.0),
//       child: ListView(
//         children: [
//           Text('  Verify Phone Number', style: AppFonts.primaryBlackFont),
//           SizedBox(height: 30.0),
//           Text(
//             '\nTo confirm your registration, please enter the code that sent to registerd phone number',
//             textAlign: TextAlign.center,
//             style: AppFonts.secondaryBlackFont,
//           ),
//           SizedBox(height: 20.0),
//           TextTimerWidget(),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 for (int i = 0; i < _controllers.length; i++)
//                 _buildOtpField(i)
//               ],
//             ),
//           ),
//           SizedBox(height: 45.0),
//           Column(
//             children: [
//               BlocListener<UserCubit, UserStates>(
//                 listener: (context, state) {
//                   if (state is VerifyRegisterPhoneOTPErrorState || state is VerifyRegisterPhoneOTPSomeThingWentWrongState) {
//                     banner(context, 'Sorry Some Thing Went Wrong or Invalid Code', AppColors.redColor);
//                   } else if (state is VerifyRegisterPhoneOTPSuccessState) {
//                     banner(context, 'Verified Success Let\'s Verify Email', AppColors.greenColor);
//                   }
//                 },
//                 child: BlocBuilder<UserCubit, UserStates>(
//                   builder: (context, state) {
//                     if (state is VerifyRegisterPhoneOTPLoadingState) {
//                       return Center(child: CustomLoadingSpinner());
//                     } else {
//                       return CustomBtn(
//                           widget: Text('Confirm', style: AppFonts.secondaryWhiteFont),
//                           size: Size(MediaQuery.of(context).size.width / 1.15, 48),
//                           color: AppColors.redColor,
//                           radius: 12.0,
//                           onPress: () {
//                             _submitOtp();
//                           }
//                         );
//                     }
//                   },
//                 ),
//               ),
//               BlocBuilder<UserCubit, UserStates>(
//                 builder: (context, state) {
//                   if (state is UserTimerCompletedState) {
//                     return Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text('\nDon’t receive a code? ', style: AppFonts.secondaryGreyFont),
//                           TxtBtn(
//                             '\nResend code',
//                             AppFonts.secondaryRedFont,
//                             () async {
//                               await BlocProvider.of<UserCubit>(context).requestPhoneOtp(BlocProvider.of<UserCubit>(context).registeredPhoneNumber);
//                               BlocProvider.of<UserCubit>(context).restartTimer();
//                             }
//                           )
//                         ],
//                       ),
//                     );
//                   } else {
//                     return SizedBox();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtpField(int index) {
//     return Container(
//       width: 65,
//       child: TextField(
//         controller: _controllers[index],
//         maxLength: 1,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         decoration: InputDecoration(
//           counterText: '',
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black54, width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.red, width: 2),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.length == 1 && index < 5) {
//             FocusScope.of(context).nextFocus();
//           } else if (value.isEmpty && index > 0) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//       ),
//     );
//   }

//   void _submitOtp() async {
//     String otpCode = _controllers.map((controller) => controller.text).join();
//     if (otpCode.isEmpty || otpCode.length < 4) {

//     } else {
//       // await BlocProvider.of<UserCubit>(context).verifyRegisterPhoneOtp(BlocProvider.of<UserCubit>(context).registeredPhoneNumber, otpCode);
//     }
//   }
// }


  // Widget _buildOtpField(int index) {
  //   return Container(
  //     width: 65,
  //     child: TextField(
  //       controller: _controllers[index],
  //       maxLength: 1,
  //       keyboardType: TextInputType.number,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //       decoration: InputDecoration(
  //         counterText: '',
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: BorderSide(color: Colors.black54, width: 2),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: BorderSide(color: Colors.red, width: 2),
  //         ),
  //       ),
  //       onChanged: (value) {
  //         if (value.length == 1 && index < 5) {
  //           FocusScope.of(context).nextFocus();
  //         } else if (value.isEmpty && index > 0) {
  //           FocusScope.of(context).previousFocus();
  //         }
  //       },
  //     ),
  //   );
  // }

  // void _submitOtp() async {
  //   String otpCode = _controllers.map((controller) => controller.text).join();
  //   if (otpCode.isEmpty || otpCode.length < 4) {

  //   } else {
  //     // await BlocProvider.of<UserCubit>(context).verifyRegisterEmailOtp(BlocProvider.of<UserCubit>(context).registeredEmail, otpCode);
  //   }
  // }