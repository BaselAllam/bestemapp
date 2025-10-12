import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class CustomLoadingSpinner extends StatefulWidget {
  const CustomLoadingSpinner({super.key});

  @override
  State<CustomLoadingSpinner> createState() => _CustomLoadingSpinnerState();
}

class _CustomLoadingSpinnerState extends State<CustomLoadingSpinner> with TickerProviderStateMixin {

  AnimationController? _animationController;

  @override
      void dispose() {
      _animationController!.dispose();
      super.dispose();
    }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: new Duration(seconds: 4), vsync: this);
    _animationController!.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: _animationController!.drive(ColorTween(begin: AppColors.primaryColor, end: AppColors.greyColor.withOpacity(0.2))),
    );
  }
}