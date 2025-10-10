import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  FavButton();

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        shape: BoxShape.circle
      ),
      alignment: Alignment.center,
      child: IconButton(
        icon: isFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        color: AppColors.redColor,
        iconSize: 20.0,
        onPressed: () {
          isFav = !isFav;
          setState(() {});
        },
      ),
    );
  }
}