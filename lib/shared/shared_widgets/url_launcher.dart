import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> openUrl(BuildContext context, String url) async {
    try {
      launchUrl(Uri.parse(url));
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some thing went wrong'), backgroundColor: AppColors.redColor));
    }
  }