import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> initData(BuildContext context) async {
  await BlocProvider.of<AppSettingsCubit>(context).checkLang();
  BlocProvider.of<AppSettingsCubit>(context).getFaq();
  // BlocProvider.of<AppSettingsCubit>(context).getColors();
  BlocProvider.of<AppSettingsCubit>(context).getCountries();
  // BlocProvider.of<CarCubit>(context).getCarMakes();
  // BlocProvider.of<CarCubit>(context).getCarShapes();
  // BlocProvider.of<CarCubit>(context).getCarSpecs();
  BlocProvider.of<CarCubit>(context).getCarsLanding();
}

Future<void> initAuthData(BuildContext context) async {
  BlocProvider.of<NotificationCubit>(context).getUserNotification();
  BlocProvider.of<CarCubit>(context).getUserCarAdsWihslist();
  BlocProvider.of<CarCubit>(context).getUserCarAds();
}