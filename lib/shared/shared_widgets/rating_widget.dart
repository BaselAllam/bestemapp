import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';



class RatingWidget extends StatefulWidget {
  final bool isClickable;
  const RatingWidget({this.isClickable = false});

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.star),
            color: selectedIndex >= 0 ? Colors.amber : AppColors.greyColor,
            iconSize: 20.0,
            onPressed: widget.isClickable ? () {
              selectedIndex = 0;
              setState(() {});
            } : () {},
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: selectedIndex >= 1 ? Colors.amber : AppColors.greyColor,
            iconSize: 20.0,
            onPressed: widget.isClickable ? () {
              selectedIndex = 1;
              setState(() {});
            } : () {},
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: selectedIndex >= 2 ? Colors.amber : AppColors.greyColor,
            iconSize: 20.0,
            onPressed: widget.isClickable ? () {
              selectedIndex = 2;
              setState(() {});
            } : () {},
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: selectedIndex >= 3 ? Colors.amber : AppColors.greyColor,
            iconSize: 20.0,
            onPressed: widget.isClickable ? () {
              selectedIndex = 3;
              setState(() {});
            } : () {},
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: selectedIndex == 4 ? Colors.amber : AppColors.greyColor,
            iconSize: 20.0,
            onPressed: widget.isClickable ? () {
              selectedIndex = 4;
              setState(() {});
            } : () {},
          ),
        ],
      ),
    );
  }
}