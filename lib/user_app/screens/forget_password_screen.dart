// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:superhero/shared/shared_theme/app_colors.dart';
// import 'package:superhero/shared/shared_theme/app_fonts.dart';
// import 'package:superhero/shared/shared_widget/back_btn.dart';
// import 'package:superhero/shared/shared_widget/custom_btn.dart';
// import 'package:superhero/shared/shared_widget/field.dart';
// import 'package:superhero/shared/shared_widget/loading_spinner.dart';
// import 'package:superhero/shared/shared_widget/snack.dart';
// import 'package:superhero/shared/shared_widget/txt_btn.dart';
// import 'package:superhero/shared/shared_widget/view_password_widget.dart';
// import 'package:superhero/user_app/logic/user_cubit.dart';
// import 'package:superhero/user_app/logic/user_state.dart';
// import 'package:superhero/user_app/views/register_screen.dart';



// class ForgotPasswordScreen extends StatefulWidget {
//   final String otp;
//   final String mobileNumner;
//   ForgotPasswordScreen({required this.otp, required this.mobileNumner});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   bool isSecure = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         leading: BackBtn(),
//       ),
//       body: Container(
//         margin: EdgeInsets.all(10.0),
//         child: ListView(
//           children: [
//             Text('  Reset Password', style: AppFonts.primaryBlackFont),
//             SizedBox(height: 30.0),
//             authField(
//               title: 'New Password',
//               inputTitle: 'Enter your new password',
//               inputStyle: AppFonts.secondaryGreyFont,
//               fillColor: AppColors.backGroundGreyColor,
//               textInputAction: TextInputAction.done,
//               keyBoardType: TextInputType.text,
//               controller: passwordController,
//               formaters: [],
//               obsecure: isSecure,
//               suffix: ViewPasswordWidget(isSecure, () { isSecure = !isSecure; setState(() {});})
//             ),
//             authField(
//               title: 'Confirm Password',
//               inputTitle: 'Enter your password again',
//               inputStyle: AppFonts.secondaryGreyFont,
//               fillColor: AppColors.backGroundGreyColor,
//               textInputAction: TextInputAction.done,
//               keyBoardType: TextInputType.text,
//               controller: confirmPasswordController,
//               formaters: [],
//               obsecure: isSecure,
//               suffix: ViewPasswordWidget(isSecure, () { isSecure = !isSecure; setState(() {});})
//             ),
//             SizedBox(height: 45.0),
//             Column(
//               children: [
//                 BlocListener<UserCubit, UserStates>(
//                     listener: (cotnext, state) async {
//                       if (state is ForgetPasswordErrorState || state is ForgetPasswordSomeThingWentWrongState) {
//                         banner(context, 'Some Thing Went Wrong', AppColors.redColor);
//                       } else if (state is ForgetPasswordSuccessState) {
//                         banner(context, 'Updated Success Back to Login ', AppColors.greenColor);
//                         await Future.delayed(Duration(seconds: 2));
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: BlocBuilder<UserCubit, UserStates>(
//                       builder: (context, state) {
//                         if (state is ForgetPasswordLoadingState) {
//                           return Center(child: CustomLoadingSpinner());
//                         } else {
//                           return CustomBtn(
//                             widget: Text('Confirm', style: AppFonts.secondaryWhiteFont),
//                             size: Size(MediaQuery.of(context).size.width / 1.15, 48),
//                             color: AppColors.redColor,
//                             radius: 12.0,
//                             onPress: () async {
//                               if (passwordController.text != confirmPasswordController.text) {
//                                 banner(context, 'Password Doesn\'t Matched', AppColors.redColor);
//                               } else if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
//                                 banner(context, 'Fields Required', AppColors.redColor);
//                               } else {
//                                 await BlocProvider.of<UserCubit>(context).forgotPassword(widget.mobileNumner, widget.otp, passwordController.text);
//                               }
//                             }
//                           );
//                         }
//                       },
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height / 3),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Don\'t have an account?', style: AppFonts.secondaryGreyFont),
//                   TxtBtn(
//                     ' Register',
//                     AppFonts.secondaryRedFont,
//                     () {
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
//                     }
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }