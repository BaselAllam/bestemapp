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
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.navBarWishlist]!, style: AppFonts.primaryFontBlackColor),
        actions: [SellBtn(), NotificationButton()],
      ),
      body: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is GetUserCarWishlistAdsLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserCarWishlistAdsErrorState || state is GetUserCarWishlistAdsSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else if (BlocProvider.of<CarCubit>(context).userWishlistCarAds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    selectedLang[AppLangAssets.noWishlist]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: BlocProvider.of<CarCubit>(context).userWishlistCarAds.length,
              itemBuilder: (context, index) => CarAdWidget(
                carAdModel: BlocProvider.of<CarCubit>(context).userWishlistCarAds[index].carAdModel,
                carAdWishlistModel: BlocProvider.of<CarCubit>(context).userWishlistCarAds[index],
                wishlistIndex: index
              )
            );
          }
        }
      ),
    );
  }
}