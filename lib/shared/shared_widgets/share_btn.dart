import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:flutter/material.dart';


class ShareBtn extends StatefulWidget {
  const ShareBtn({super.key});

  @override
  State<ShareBtn> createState() => _ShareBtnState();
}

class _ShareBtnState extends State<ShareBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        shape: BoxShape.circle
      ),
      child: IconButton(
        icon: Image.asset(AppAssets.shareIcon, height: 20.0, width: 20.0),
        color: AppColors.primaryColor,
        iconSize: 15.0,
        onPressed: () {},  
      ),
    );
  }
}