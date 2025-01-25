import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class ImgIconBtn extends StatefulWidget {
  final String imgPath;
  Function onPress;
  ImgIconBtn({required this.imgPath, required this.onPress});

  @override
  State<ImgIconBtn> createState() => _ImgIconBtnState();
}

class _ImgIconBtnState extends State<ImgIconBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(widget.imgPath),
      color: AppColors.blackColor,
      iconSize: 24,
      onPressed: () {
        widget.onPress();
      },
    );
  }
}