import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class StoreFav extends StatefulWidget {
  const StoreFav({super.key});

  @override
  State<StoreFav> createState() => _StoreFavState();
}

class _StoreFavState extends State<StoreFav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteColor
      ),
      child: IconButton(
        icon: const Icon(Icons.favorite),
        color: AppColors.primaryColor,
        iconSize: 25.0,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => AddAdScreen()));
        },
      ),
    );
  }
}