import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/utils/init_data.dart';
import 'package:bestemapp/user_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final bool isNotification;
  SplashScreen({required this.isNotification});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: fun(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return AuthScreen();
            // if (widget.isNotification) {
            //   return NotificationScreen(isNotification: widget.isNotification);
            // } else if (snapshot.data == 'home') {
            //   return BottomNavBar();
            // } else if (snapshot.data == 'welcome') {
            //   return OnBoardingScreen();
            // } else if (snapshot.data == 'redirectPhone') {
            //   return PhoneOTPScreen();
            // } else if (snapshot.data == 'redirectEmail') {
            //   return EmailOTPScreen();
            // } else if (snapshot.data == 'errorScreen') {
            //   return ErrorScreen();
            // }
          }
          return Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoContainer(size: Size(300, 300)),
                  SizedBox(height: 20.0,),
                  CustomLoadingSpinner(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> fun() async {
    await Future.delayed(Duration(seconds: 2));
    // // bool isLogin = await getBoolFromLocal(AppAssets.isLogIn);
    // String screen = '';
    // if (isLogin) {
    //   screen = await BlocProvider.of<UserCubit>(context).getUserData();
    // } else {
    //   screen = 'welcome';
    // }
    // if (screen == 'home' || screen == 'redirectEmail' || screen == 'redirectPhone') {
    //   await initData(context);
    // }
    await initData(context);
     return 'screen';
  }
}