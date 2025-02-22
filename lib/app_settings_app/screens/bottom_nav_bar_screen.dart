import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/screens/bookings_screen.dart';
import 'package:bestemapp/app_settings_app/screens/fav_screen.dart';
import 'package:bestemapp/app_settings_app/screens/home_screen.dart';
import 'package:bestemapp/app_settings_app/screens/more_screen.dart';
import 'package:bestemapp/app_settings_app/screens/store_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  
  final List<Map<String, dynamic>> bottomScreens = [
    {
      'activeIcon': Image.asset(AppAssets.homeIcon, height: 25.0, width: 25.0),
      'icon': Image.asset(AppAssets.emptyHomeIcon, height: 25.0, width: 25.0),
      'title': selectedLang[AppLangAssets.navBarHome],
      'screen': HomeScreen()
    },
    {
      'activeIcon': Image.asset(AppAssets.bookingNavIcon, height: 25.0, width: 25.0),
      'icon': Image.asset(AppAssets.emptyBookingNavIcon, height: 25.0, width: 25.0),
      'title': selectedLang[AppLangAssets.navBarBooking],
      'screen': BookingsScreen()
    },
    {
      'activeIcon': Image.asset(AppAssets.storeNavIcon, height: 30.0, width: 30.0),
      'icon': Image.asset(AppAssets.emptyStoreNavIcon, height: 30.0, width: 30.0),
      'title': selectedLang[AppLangAssets.navBarStore],
      'screen': StoreScreen()
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

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.ofWhiteColor,
        currentIndex: currentIndex,
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.blackColor,
        unselectedItemColor: AppColors.blackColor,
        selectedLabelStyle: AppFonts.miniFontBlackColor,
        unselectedLabelStyle: AppFonts.miniFontBlackColor,
        items: [
          for (var i in bottomScreens)
          BottomNavigationBarItem(
            activeIcon: i['activeIcon'],
            icon: i['icon'],
            label: i['title']
          )
        ],
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
      body: bottomScreens[currentIndex]['screen'],
    );
  }
}