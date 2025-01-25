// import 'package:bestemapp/shared/shared_theme/app_colors.dart';
// import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ResetPasswordPhoneOTPScreen extends StatefulWidget {
//   const ResetPasswordPhoneOTPScreen();

//   @override
//   State<ResetPasswordPhoneOTPScreen> createState() => _ResetPasswordPhoneOTPScreenState();
// }

// class _ResetPasswordPhoneOTPScreenState extends State<ResetPasswordPhoneOTPScreen> {

//   List<TextEditingController> _controllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

//   String selectedCountry = 'EG';

//   TextEditingController numberController = TextEditingController();

//   bool showOTP = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         leading: BackBtn(),
//       ),
//       body: Container(
//         margin: EdgeInsets.all(10.0),
//         child: BlocBuilder<UserCubit, UserStates>(
//           builder: (context, state) {
//             return ListView(
//               children: [
//                 Text('  Verification Code', style: AppFonts.primaryBlackFont),
//                 Text(
//                   '\nTo reset your password, please enter your phone that register before\n',
//                   textAlign: TextAlign.center,
//                   style: AppFonts.secondaryBlackFont,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 13.0, right: 20.0),
//                   child: Row(
//                     children: [
//                       PopupMenuButton(
//                         color: AppColors.whiteColor,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppColors.geryFontColor, width: 0.5),
//                             borderRadius: BorderRadius.circular(5.0),
//                           ),
//                           alignment: Alignment.center,
//                           padding: EdgeInsets.all(14),
//                           child: Text(countryData[selectedCountry]!['countryFlag']!, style: AppFonts.secondaryBlackFont)
//                         ),
//                         itemBuilder: (context) {
//                           return <PopupMenuEntry<String>>[
//                             for (String i in countryData.keys)
//                             PopupMenuItem(
//                               child: Text('${countryData[i]!['countryFlag']}   ${countryData[i]!['countryName']} ${countryData[i]!['countryCode']}', style: AppFonts.miniBlackFont),
//                               value: i,
//                             ),
//                           ];
//                         },
//                         onSelected: (v) {
//                           setState(() {
//                             selectedCountry = v;
//                           });
//                         },
//                       ),
//                       // SizedBox(width: 8),
//                       Expanded(
//                         child: customField(
//                           inputTitle: 'Enter your number',
//                           inputStyle: AppFonts.secondaryGreyFont,
//                           fillColor: AppColors.backGroundGreyColor,
//                           textInputAction: TextInputAction.done,
//                           keyBoardType: TextInputType.number,
//                           controller: numberController,
//                           formaters: [FilteringTextInputFormatter.digitsOnly],
//                           enabled: !showOTP
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30.0),
//                 Column(
//                   children: [
//                     BlocBuilder<UserCubit, UserStates>(
//                       builder: (context, state) {
//                         if (state is RequestPhoneOTPRegisterSuccessState) {showOTP = true;}
//                         if (state is RequestPhoneOTPRegisterLoadingState) {
//                           return Center(child: CustomLoadingSpinner());
//                         } else {
//                           return CustomBtn(
//                             widget: Text('Confirm', style: AppFonts.secondaryWhiteFont),
//                             size: Size(MediaQuery.of(context).size.width / 1.15, 48),
//                             color: AppColors.redColor,
//                             radius: 12.0,
//                             onPress: state is RequestPhoneOTPRegisterSuccessState ? () {} : () async {
//                               if (numberController.text.isNotEmpty) {
//                                 await BlocProvider.of<UserCubit>(context).requestPhoneOtp('${countryData[selectedCountry]!['countryCode']!}${numberController.text}');
//                               }
//                             }
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 if (showOTP)
//                 buildOtpSection(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   buildOtpSection() {
//     return Column(
//       children: [
//         Text(
//           '\nTo confirm your registration, please enter the code that sent to your Phone Number',
//           textAlign: TextAlign.center,
//           style: AppFonts.secondaryBlackFont,
//         ),
//         SizedBox(height: 20.0),
//         TextTimerWidget(),
//         Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               for (int i = 0; i < _controllers.length; i++)
//               _buildOtpField(i)
//             ],
//           ),
//         ),
//         SizedBox(height: 45.0),
//         Column(
//           children: [
//             CustomBtn(
//               widget: Text('Confirm', style: AppFonts.secondaryWhiteFont),
//               size: Size(MediaQuery.of(context).size.width / 1.15, 48),
//               color: AppColors.redColor,
//               radius: 12.0,
//               onPress: () {
//                 _submitOtp();
//               }
//             ),
//             BlocBuilder<UserCubit, UserStates>(
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
//                               await BlocProvider.of<UserCubit>(context).requestPhoneOtp('${countryData[selectedCountry]!['countryCode']!}${numberController.text}');
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
//           ],
//         ),
//       ],
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
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen(otp: otpCode, mobileNumner: '${countryData[selectedCountry]!['countryCode']!}${numberController.text}')));
//     }
//   }
// }