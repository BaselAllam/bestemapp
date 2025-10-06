import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';


class FilterWidget extends StatefulWidget {
  final IconData icon;
  final String txt;
  Function onTap;
  FilterWidget({required this.icon, required this.txt, required this.onTap});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        width: 100.0,
        height: 30.0,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor, width: 0.5),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: AppColors.greyColor, size: 20.0),
            Text('  ${widget.txt}', style: AppFonts.miniFontGreyColor)
          ],
        ),
      ),
    );
  }
}