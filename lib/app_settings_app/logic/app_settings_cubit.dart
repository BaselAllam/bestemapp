import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsCubit extends Cubit<AppSettingsStates> {

  AppSettingsCubit() : super(InitAppSettingsState());

  int selectedOnBoardingScreen = 1;

  final Map<int, Map<String, dynamic>> onBoardingScreens = {
    1: {
      'img': AppAssets.onBoarding1,
      'title': AppLangAssets.onBoardingOneTitle,
      'subTitle': AppLangAssets.onBoardingOneSubTitle
    },
    2: {
      'img': AppAssets.onBoarding2,
      'title': AppLangAssets.onBoardingTwoTitle,
      'subTitle': AppLangAssets.onBoardingTwoSubTitle
    },
    3: {
      'img': AppAssets.onBoarding3,
      'title': AppLangAssets.onBoardingThreeTitle,
      'subTitle': AppLangAssets.onBoardingThreeSubTitle
    },
  };

  void updateOnPording(int key) {
    selectedOnBoardingScreen = key;
    emit(ChangeOnBoardingAppSettingsState());
  }
}