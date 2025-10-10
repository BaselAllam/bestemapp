import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';


class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.myAds]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, state) => CarAdWidget(car: {
          'id': '1',
          'title': '2023 Toyota Camry SE',
          'price': 28500,
          'year': 2023,
          'mileage': 12500,
          'location': 'Los Angeles, CA',
          'transmission': 'Automatic',
          'fuelType': 'Hybrid',
          'image': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800',
          'condition': 'Like New',
          'seller': 'Premium Dealer',
          'isFeatured': true,
          'isVerified': true,
        },),
      ),
    );
  }
}