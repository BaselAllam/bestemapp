import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';



class ViewPasswordWidget extends StatefulWidget {
  bool isSecure;
  Function onPress;
  ViewPasswordWidget(this.isSecure, this.onPress);

  @override
  State<ViewPasswordWidget> createState() => _ViewPasswordWidgetState();
}

class _ViewPasswordWidgetState extends State<ViewPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.isSecure ? Icons.visibility_off_outlined : Icons.visibility),
      color: AppColors.greyColor,
      iconSize: 24,
      onPressed: () {
        widget.onPress();
      },
    );
  }
}