import 'package:flutter/material.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';

class BackBtn extends StatefulWidget {
  const BackBtn({super.key});

  @override
  State<BackBtn> createState() => _BackBtnState();
}

class _BackBtnState extends State<BackBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      color: AppColors.blackColor,
      iconSize: 25.0,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}