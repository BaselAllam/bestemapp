import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/lang/en.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Map<String, String> selectedLang = enData;
enum LanguageOption {ar, en}

class AppSettingsCubit extends Cubit<AppSettingsStates> {

  AppSettingsCubit() : super(InitAppSettingsState());

  LanguageOption _selectedLangOption = LanguageOption.en;
  LanguageOption get selectedLangOption => _selectedLangOption;
  Locale _selectedLocale = Locale('en');
  Locale get selectedLocale => _selectedLocale;

  void changeLanguage(LanguageOption newLang) {
    _selectedLangOption = newLang;
    if (newLang == LanguageOption.ar) _selectedLocale = Locale('ar');
    if (newLang == LanguageOption.en) _selectedLocale = Locale('en');
    emit(ChangeLanguageState());
  }

  // int selectedOnBoardingScreen = 1;

  // final Map<int, Map<String, dynamic>> onBoardingScreens = {
  //   1: {
  //     'img': AppAssets.onBoarding1,
  //     'title': AppLangAssets.onBoardingOneTitle,
  //     'subTitle': AppLangAssets.onBoardingOneSubTitle
  //   },
  //   2: {
  //     'img': AppAssets.onBoarding2,
  //     'title': AppLangAssets.onBoardingTwoTitle,
  //     'subTitle': AppLangAssets.onBoardingTwoSubTitle
  //   },
  //   3: {
  //     'img': AppAssets.onBoarding3,
  //     'title': AppLangAssets.onBoardingThreeTitle,
  //     'subTitle': AppLangAssets.onBoardingThreeSubTitle
  //   },
  // };

  // void updateOnPording(int key) {
  //   selectedOnBoardingScreen = key;
  //   emit(ChangeOnBoardingAppSettingsState());
  // }

  String _selectedHomeFilter = selectedLang[AppLangAssets.cars]!;
  String get selectedHomeFilter => _selectedHomeFilter;

  void changeHomeFilter(String selectedTitle) {
    _selectedHomeFilter = selectedTitle;
    emit(ChangeHomeFilterState());
  }
}