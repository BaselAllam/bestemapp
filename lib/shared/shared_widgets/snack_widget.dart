import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';



snack(String message, Color color) {
  return SnackBar(
    content: Text(message, style: AppFonts.miniFontWhiteColor),
    duration: Duration(seconds: 3),
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
  );
}