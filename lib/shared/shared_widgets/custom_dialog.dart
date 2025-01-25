import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';


showCustomDialog(BuildContext context, {required Size dialogSize, required String dialogTitle, required Widget dialogBody, required Widget dialogActions}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        alignment: Alignment.center,
        backgroundColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(dialogTitle, style: AppFonts.primaryFontBlackColor, textAlign: TextAlign.center),
        children: [
          Divider(color: AppColors.greyColor, endIndent: 30.0, indent: 30.0, thickness: 1.0),
          SizedBox(height: 20.0),
          dialogBody,
          SizedBox(height: 20.0),
          dialogActions,
          SizedBox(height: 10.0)
        ],
      );
    }
  );
}