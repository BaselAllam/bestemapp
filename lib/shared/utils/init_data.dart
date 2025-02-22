import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool isInitLoading = false;

Future<void> initData(BuildContext context) async {
  isInitLoading = true;
  await BlocProvider.of<AppSettingsCubit>(context).checkLang();
  isInitLoading = false;
}