import 'package:bestemapp/ads_app/screens/search_result_screen.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/booking_widget.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text('${selectedLang[AppLangAssets.homeWlcTitle]} Bassel Allam 👋', style: AppFonts.primaryFontBlackColor),
        actions: [NotificationButton()],
      ),
      body: ListView(
        children: [
          buildAdsSection(),
          sectionTitle('${selectedLang[AppLangAssets.booking]} ', false),
          buildBookingSection(),
          sectionTitle('${selectedLang[AppLangAssets.iLike]} ', false),
          buildTabs(),
          sectionTitle('${selectedLang[AppLangAssets.popular]} ', true),
          buildItemsSection(),
          sectionTitle('${selectedLang[AppLangAssets.recentlyAdded]} ', true),
          buildItemsSection(),
        ],
      ),
    );
  }

  buildBookingSection() {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < 5; i++)
          BookingWidget(isHomeView: true)
        ],
      ),
    );
  }

  sectionTitle(String title, bool showSeeMore) {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) {
        return ListTile(
          title: Row(
            children: [
              Text(title, style: AppFonts.primaryFontBlackColor),
              if (showSeeMore)
              Text(BlocProvider.of<AppSettingsCubit>(context).selectedHomeFilter, style: AppFonts.italicPrimaryFontOrangeColor),
            ],
          ),
          trailing: showSeeMore ? Text(selectedLang[AppLangAssets.seeMore]!, style: AppFonts.miniFontGreyColor) : SizedBox(),
          onTap: !showSeeMore ? () {} : () {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => SearchResultScreen(screenTitle: title)));
          },
        );
      },
    );
  }

  buildAdsSection() {
    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          animateToClosest: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
          initialPage: 0,
          enlargeCenterPage: true,
          pauseAutoPlayOnTouch: true,
        ),
        items: ['https://images.pexels.com/photos/164634/pexels-photo-164634.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/244206/pexels-photo-244206.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/707046/pexels-photo-707046.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=600',
        'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=600'].map((i) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: NetworkImage(i),
                fit: BoxFit.fill
              )
            ),
          );
        }).toList(),
      ),
    );
  }

  buildTabs() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          tabItem(selectedLang[AppLangAssets.cars]!),
          tabItem(selectedLang[AppLangAssets.motorBikes]!),
          tabItem(selectedLang[AppLangAssets.bikes]!),
        ],
      ),
    );
  }

  tabItem(String title) {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) => InkWell(
        onTap: () {
          BlocProvider.of<AppSettingsCubit>(context).changeHomeFilter(title);
        },
        child: Container(
          height: 40.0,
          width: title.length * 13,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: BlocProvider.of<AppSettingsCubit>(context).selectedHomeFilter == title ? AppColors.primaryColor : AppColors.whiteColor,
          ),
          alignment: Alignment.center,
          child: Text(title, style: BlocProvider.of<AppSettingsCubit>(context).selectedHomeFilter == title ? AppFonts.subFontWhiteColor : AppFonts.subFontBlackColor),
        ),
      ),
    );
  }

  buildItemsSection() {
    return Container(
      height: 470.0,
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) => AdWidget(imgHieght: 200,),
      ),
    );
  }
}