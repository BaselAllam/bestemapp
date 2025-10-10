import 'package:bestemapp/app_settings_app/screens/bottom_nav_bar_screen.dart';
import 'package:bestemapp/app_settings_app/screens/onboarding_screen.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/init_data.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    checkInitApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LogoContainer(size: Size(300, 300)),
      ),
    );
  }

  void checkInitApp() async {
    await Future.delayed(Duration(seconds: 1));
    await initData(context);
    bool isLogin = await getBoolFromLocal(AppApi.userToken);
    if (!isLogin) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => OnboardingScreen()));
      return;
    }
    String screen = '';
    screen = await BlocProvider.of<UserCubit>(context).getUserData();
    if (screen == 'welcome') {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => OnboardingScreen()));
    } else if (screen == 'home') {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => BottomNavBarScreen()));
    } else if (screen == 'redirectPhone') {
      // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => BottomNavBarScreen()));
    }
    
  }
}