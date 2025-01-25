import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
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
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        shape: BoxShape.circle
      ),
      child: IconButton(
        icon: isFav ? Image.asset(AppAssets.favIcon, height: 20.0, width: 20.0,) : Image.asset(AppAssets.addToFavIcon, height: 20.0, width: 20.0,),
        color: AppColors.redColor,
        iconSize: 15.0,
        onPressed: () {
          isFav = !isFav;
          setState(() {});
        },
      ),
    );
  }
}