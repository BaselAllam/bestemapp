import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> initData(BuildContext context) async {
  await BlocProvider.of<AppSettingsCubit>(context).checkLang();
  await BlocProvider.of<AppSettingsCubit>(context).getLandingBanners();
  await BlocProvider.of<AppSettingsCubit>(context).getFaq();
  await BlocProvider.of<AppSettingsCubit>(context).getColors();
  await BlocProvider.of<AppSettingsCubit>(context).getCountries();
  await BlocProvider.of<CarCubit>(context).getCarMakes();
  await BlocProvider.of<CarCubit>(context).getCarShapes();
  await BlocProvider.of<CarCubit>(context).getCarSpecs();
  await BlocProvider.of<CarCubit>(context).getCarsLanding();
}

Future<void> initAuthData(BuildContext context) async {
  BlocProvider.of<NotificationCubit>(context).getUserNotification();
  BlocProvider.of<CarCubit>(context).getUserCarAdsWihslist();
  BlocProvider.of<CarCubit>(context).getUserCarAds();
}