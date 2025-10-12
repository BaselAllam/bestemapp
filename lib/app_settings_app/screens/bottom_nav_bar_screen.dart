import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.whiteColor,
          currentIndex: BlocProvider.of<AppSettingsCubit>(context).selectedNavIndex,
          elevation: 0.0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.blackColor,
          unselectedItemColor: AppColors.blackColor,
          selectedLabelStyle: AppFonts.miniFontBlackColor,
          unselectedLabelStyle: AppFonts.miniFontBlackColor,
          items: [
            for (var i in BlocProvider.of<AppSettingsCubit>(context).bottomScreens)
            BottomNavigationBarItem(
              activeIcon: i['activeIcon'],
              icon: i['icon'],
              label: i['title']
            )
          ],
          onTap: (index) {
            BlocProvider.of<AppSettingsCubit>(context).changeNav(index);
          },
        ),
        body: BlocProvider.of<AppSettingsCubit>(context).bottomScreens[BlocProvider.of<AppSettingsCubit>(context).selectedNavIndex]['screen'],
      ),
    );
  }
}