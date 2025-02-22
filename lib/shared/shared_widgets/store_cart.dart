import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class StoreCart extends StatefulWidget {
  const StoreCart({super.key});

  @override
  State<StoreCart> createState() => _StoreCartState();
}

class _StoreCartState extends State<StoreCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor
      ),
      child: IconButton(
        icon: const Icon(Icons.shopping_basket_outlined),
        color: AppColors.primaryColor,
        iconSize: 25.0,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => AddAdScreen()));
        },
      ),
    );
  }
}