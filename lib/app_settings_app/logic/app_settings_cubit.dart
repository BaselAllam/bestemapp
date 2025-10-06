import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/lang/en.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bestemapp/app_settings_app/screens/fav_screen.dart';
import 'package:bestemapp/app_settings_app/screens/home_screen.dart';
import 'package:bestemapp/app_settings_app/screens/more_screen.dart';

Map<String, String> selectedLang = enData;
enum LanguageOption {ar, en}

class AppSettingsCubit extends Cubit<AppSettingsStates> {

  AppSettingsCubit() : super(InitAppSettingsState());

  LanguageOption _selectedLangOption = LanguageOption.en;
  LanguageOption get selectedLangOption => _selectedLangOption;
  Locale _selectedLocale = Locale('en');
  Locale get selectedLocale => _selectedLocale;

  final List<Map<String, dynamic>> bottomScreens = [
    {
      'activeIcon': Image.asset(AppAssets.homeIcon, height: 25.0, width: 25.0),
      'icon': Image.asset(AppAssets.emptyHomeIcon, height: 25.0, width: 25.0),
      'title': selectedLang[AppLangAssets.navBarHome],
      'screen': HomeScreen()
    },
    {
      'activeIcon': Image.asset(AppAssets.favIcon, height: 25.0, width: 25.0),
      'icon': Image.asset(AppAssets.emptyFavIcon, height: 25.0, width: 25.0),
      'title': selectedLang[AppLangAssets.navBarWishlist],
      'screen': FavScreen()
    },
    {
      'activeIcon': Image.asset(AppAssets.moreIcon, height: 25.0, width: 25.0),
      'icon': Image.asset(AppAssets.emptyMoreIcon, height: 25.0, width: 25.0),
      'title': selectedLang[AppLangAssets.navBarMore],
      'screen': MoreScreen()
    },
  ];

  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  void changeNav(int index) {
    _selectedNavIndex = index;
    emit(ChangeNavState());
  }

  Future<void> changeLanguage(LanguageOption newLang) async {
    _selectedLangOption = newLang;
    if (newLang == LanguageOption.ar) {
      _selectedLocale = Locale('ar');
      // selectedLang = arData;
      saveStringToLocal(AppAssets.appLang, LanguageOption.ar.name);
    } else if (newLang == LanguageOption.en) {
      _selectedLocale = Locale('en');
      // selectedLang = enData;
      saveStringToLocal(AppAssets.appLang, 'en');
    }
    emit(ChangeLanguageState());
  }

  Future<void> checkLang() async {
    String lang = await getStringFromLocal(AppAssets.appLang);
    if (lang == LanguageOption.ar.name) {
      _selectedLangOption = LanguageOption.ar;
      _selectedLocale = Locale('ar');
      // selectedLang = arData;
      saveStringToLocal(AppAssets.appLang, 'ar');
    } else if (lang == LanguageOption.en.name || lang.isEmpty) {
      _selectedLangOption = LanguageOption.en;
      _selectedLocale = Locale('en');
      // selectedLang = enData;
      saveStringToLocal(AppAssets.appLang, LanguageOption.en.name);
    }
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
}