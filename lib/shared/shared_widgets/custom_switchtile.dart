import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';




class CustomSwitchTile extends StatefulWidget {
  final String title;
  final String subTitle;
  final Widget? leading;
  bool value;
  Function(bool)? onChange;
  CustomSwitchTile({required this.title, this.onChange, this.value = false, this.subTitle = '', this.leading});

  @override
  State<CustomSwitchTile> createState() => _CustomSwitchTileState();
}

class _CustomSwitchTileState extends State<CustomSwitchTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title, style: AppFonts.subFontBlackColor),
      subtitle: widget.subTitle.isEmpty ? null : Text(widget.subTitle, style: AppFonts.subFontGreyColor),
      leading: widget.leading,
      trailing: Switch(
        value: widget.value,
        activeColor: AppColors.whiteColor,
        activeTrackColor: AppColors.redColor,
        hoverColor: AppColors.redColor,
        inactiveThumbColor: AppColors.whiteColor,
        inactiveTrackColor: AppColors.greyColor,
        onChanged: widget.onChange,
      ),
    );
  }
}