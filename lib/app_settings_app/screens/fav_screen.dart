import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/car_app/widgets/sell_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        title: Text(
          selectedLang[AppLangAssets.navBarWishlist]!,
          style: AppFonts.primaryFontBlackColor,
        ),
        actions: [
          SellBtn(),
          NotificationButton(),
        ],
      ),
      body: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is GetUserCarWishlistAdsLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserCarWishlistAdsErrorState ||
              state is GetUserCarWishlistAdsSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else if (BlocProvider.of<CarCubit>(context).userWishlistCarAds.isEmpty) {
            return _buildEmptyState();
          } else {
            return _buildWishlistContent(context);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedLang[AppLangAssets.noWishlist]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              selectedLang[AppLangAssets.noWishlist]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to browse cars
              },
              icon: const Icon(Icons.search_rounded, size: 20),
              label: Text(selectedLang[AppLangAssets.search]!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.whiteColor,
                foregroundColor: Colors.grey[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context) {
    final carCubit = BlocProvider.of<CarCubit>(context);
    final wishlistCount = carCubit.userWishlistCarAds.length;

    return Column(
      children: [
        // Stats header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.favorite_rounded, size: 18, color: Colors.red[400]),
              const SizedBox(width: 8),
              Text(
                '$wishlistCount ${wishlistCount == 1 ? 'Car' : 'Cars'} Saved',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        
        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: wishlistCount,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CarAdWidget(
                carAdModel: carCubit.userWishlistCarAds[index].carAdModel,
                carAdWishlistModel: carCubit.userWishlistCarAds[index],
                wishlistIndex: index,
              ),
            ),
          ),
        ),
      ],
    );
  }
}