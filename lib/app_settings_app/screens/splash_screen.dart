import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/screens/bottom_nav_bar_screen.dart';
import 'package:bestemapp/app_settings_app/screens/onboarding_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/logo_container.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/shared/utils/init_data.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:bestemapp/user_app/screens/verify_phone_otp.dart';
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
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: LogoContainer(size: Size(300, 300)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: AnimatedLoadingText(
                text: selectedLang[AppLangAssets.fetchingData]!,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                dotCount: 4,
                slowMessage: selectedLang[AppLangAssets.takesLonger]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkInitApp() async {
    await Future.delayed(Duration(seconds: 1));
    await initData(context);
    String userToken = await getStringFromLocal(AppApi.userToken);
    if (userToken.isEmpty) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => OnboardingScreen()));
      return;
    }
    await initAuthData(context);
    String screen = '';
    screen = await BlocProvider.of<UserCubit>(context).getUserData();
    if (screen == 'welcome') {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => OnboardingScreen()));
    } else if (screen == 'home') {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => BottomNavBarScreen()));
    } else if (screen == 'redirectPhone') {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => VerifyPhoneOTPScreen(phoneNumber: BlocProvider.of<UserCubit>(context).userModel!.phone)));
    }
    
  }
}

class AnimatedLoadingText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final int dotCount;
  final Duration animationDuration;
  final Duration slowMessageDelay;
  final String slowMessage;

  const AnimatedLoadingText({
    Key? key,
    this.text = 'Loading data',
    this.textStyle,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 500),
    this.slowMessageDelay = const Duration(seconds: 4),
    this.slowMessage = 'Sorry, we are still loading data',
  }) : super(key: key);

  @override
  State<AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showSlowMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();

    // Show slow message after delay
    Future.delayed(widget.slowMessageDelay, () {
      if (mounted) {
        setState(() {
          _showSlowMessage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _controller.value;
            final activeDots = (progress * (widget.dotCount + 1)).floor();
            final dots = List.generate(
              widget.dotCount,
              (index) => index < activeDots ? '.' : ' ',
            ).join();

            return RichText(
              text: TextSpan(
                style: widget.textStyle ??
                    Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(text: widget.text),
                  TextSpan(
                    text: dots,
                    style: const TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _showSlowMessage
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.slowMessage,
                    style: (widget.textStyle ?? Theme.of(context).textTheme.bodyMedium)
                        ?.copyWith(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}