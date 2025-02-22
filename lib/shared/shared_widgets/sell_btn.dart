import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class SellBtn extends StatefulWidget {
  const SellBtn({super.key});

  @override
  State<SellBtn> createState() => _SellBtnState();
}

class _SellBtnState extends State<SellBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        color: AppColors.primaryColor,
        iconSize: 30.0,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => AddAdScreen()));
        },
      ),
    );
  }
}