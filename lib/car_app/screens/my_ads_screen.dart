import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/back_btn.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/no_result_found.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        title: Text(selectedLang[AppLangAssets.myAds]!, style: AppFonts.primaryFontBlackColor),
        leading: BackBtn(),
      ),
      body: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is GetUserCarAdsLoadingState) {
            return Center(child: CustomLoadingSpinner());
          } else if (state is GetUserCarAdsErrorState) {
            return Center(child: CustomErrorWidget(errorMessage: state.errorMsg));
          } else if (state is GetUserCarAdsSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else if (BlocProvider.of<CarCubit>(context).userCarAds.isEmpty) {
            return Center(child: NoResultFoundWidget());
          } else {
            return ListView.builder(
              itemCount: BlocProvider.of<CarCubit>(context).userCarAds.length,
              itemBuilder: (context, index) => CarAdWidget(carAdModel: BlocProvider.of<CarCubit>(context).userCarAds[index], isAdminView: true),
            );
          }
        }
      ),
    );
  }
}