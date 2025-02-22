import 'package:bestemapp/ads_app/screens/my_ads_screen.dart';
import 'package:bestemapp/ads_app/screens/my_reviews_screen.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/app_settings_app/screens/about_us_screen.dart';
import 'package:bestemapp/app_settings_app/screens/privacy_policy_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_dialog.dart';
import 'package:bestemapp/shared/shared_widgets/custom_switchtile.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/ads_app/widgets/sell_btn.dart';
import 'package:bestemapp/shared/shared_widgets/url_launcher.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/ticketing_app/views/tickets_screen.dart';
import 'package:bestemapp/store_app/views/my_addresses_screen.dart';
import 'package:bestemapp/user_app/screens/user_profile_screen.dart';
import 'package:bestemapp/user_app/screens/wallet_transactions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  final List<Map<String, dynamic>> social = [{'icon': AppAssets.webIcon, 'url': 'https://bestem.app'}, {'icon': AppAssets.facebookIcon, 'url': 'https://www.facebook.com/profile.php?id=61572279167259'}, {'icon': AppAssets.instagramIcon, 'url': 'https://www.instagram.com/bestem.app/?hl=en'}, {'icon': AppAssets.linkedinIcon, 'url': 'https://basselallam.com'}];

  String versionNumber = '';
  bool isAcceptNotifications = true;

  @override
  void initState() {
    getAppVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text(selectedLang[AppLangAssets.navBarMore]!, style: AppFonts.primaryFontBlackColor),
        actions: [SellBtn(), NotificationButton()],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                height: 120.0,
                width: 120,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://avatars.githubusercontent.com/u/44323531?v=4'),
                    fit: BoxFit.contain
                  )
                ),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
          sectionTitle(selectedLang[AppLangAssets.profileData]!),
          sectionContainer(
            Column(
              children: [
                sectionSubWidget(icon: AppAssets.personIcon, title: selectedLang[AppLangAssets.myProfile]!, screen: UserProfileScreen()),
                sectionSubWidget(icon: AppAssets.myAdsIcon, title: selectedLang[AppLangAssets.myAds]!, screen: MyAdsScreen()),
                sectionSubWidget(icon: AppAssets.walletIcon, title: selectedLang[AppLangAssets.myWalletTransactions]!, screen: WalletTransactionsScreen()),
                sectionSubWidget(icon: AppAssets.adressIcon, title: selectedLang[AppLangAssets.myAddresses]!, screen: MyAddressesScreen()),
                sectionSubWidget(icon: AppAssets.myReviewsIcon, title: selectedLang[AppLangAssets.myReviews]!, screen: MyReviewsScreen()),
              ],
            )
          ),
          sectionTitle(selectedLang[AppLangAssets.settingsSection]!),
          sectionContainer(
            Column(
              children: [
                buildChangeLanguage(),
                CustomSwitchTile(
                  title: selectedLang[AppLangAssets.acceptNotification]!,
                  leading: Image.asset(AppAssets.acceptNotificationIcon, height: 25, width: 25.0),
                  value: isAcceptNotifications,
                  onChange: (v) {
                    isAcceptNotifications = v;
                    setState(() {});
                  },
                )
              ],
            )
          ),
          sectionTitle(selectedLang[AppLangAssets.appSection]!),
          sectionContainer(
            Column(
              children: [
                sectionSubWidget(icon: AppAssets.aboutUsIcon, title: selectedLang[AppLangAssets.aboutUs]!, screen: AboutUsScreen()),
                sectionSubWidget(icon: AppAssets.helpDeskIcon, title: selectedLang[AppLangAssets.getSupport]!, screen: TicketsScreen()),
                sectionSubWidget(icon: AppAssets.privacyPolicyIcon, title: selectedLang[AppLangAssets.privacyPolicy]!, screen: PrivacyPolicySreen()),
              ],
            )
          ),
          sectionTitle(selectedLang[AppLangAssets.followUs]!),
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < social.length; i++)
                IconButton(
                  icon: Image.asset(social[i]['icon']!, height: 30.0, width: 30.0,),
                  iconSize: 30.0,
                  onPressed: () {
                    openUrl(context, social[i]['url']!);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.whiteColor,
            ),
            child: ListTile(
              title: Text(selectedLang[AppLangAssets.appVersion]!, style: AppFonts.primaryFontBlackColor),
              subtitle: Text(versionNumber, style: AppFonts.subFontGreyColor),
              leading: Image.asset(AppAssets.appVersionIcon, height: 25, width: 25.0),
            ),
          ),
          buildLogoutBtn()
        ],
      ),
    );
  }

  buildChangeLanguage() {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) => ListTile(
        leading: Image.asset(AppAssets.langIcon, height: 25, width: 25.0),
        title: Text(selectedLang[AppLangAssets.changeLang]!, style: AppFonts.primaryFontBlackColor),
        trailing: PopupMenuButton(
          color: AppColors.whiteColor,
          icon: Icon(Icons.arrow_downward, color: AppColors.primaryColor, size: 20.0),
          onSelected: (value) {
            showCustomDialog(
              context,
              dialogTitle: selectedLang[AppLangAssets.changeLang]!,
              dialogBody: Text(selectedLang[AppLangAssets.areUSureLang]!, style: AppFonts.subFontGreyColor),
              dialogSize: Size(200, 300),
              dialogActions: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.no]!, style: AppFonts.miniFontGreenColor),
                    size: Size(100.0, 30.0),
                    color: AppColors.ofWhiteColor,
                    radius: 15.0,
                    onPress: () {
                      Navigator.pop(context);
                    }
                  ),
                  CustomBtn(
                    widget: Text(selectedLang[AppLangAssets.yes]!, style: AppFonts.miniFontWhiteColor),
                    size: Size(100.0, 30.0),
                    color: AppColors.redColor,
                    radius: 15.0,
                    onPress: () async {
                      await BlocProvider.of<AppSettingsCubit>(context).changeLanguage(value);
                      Navigator.pop(context);
                    }
                  ),
                ],
              )
            );
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<LanguageOption>>[
              PopupMenuItem(
                child: Text(selectedLang[AppLangAssets.ar]!, style: AppFonts.subFontBlackColor),
                value: LanguageOption.ar,
              ),
              PopupMenuItem(
                child: Text(selectedLang[AppLangAssets.en]!, style: AppFonts.subFontBlackColor),
                value: LanguageOption.en
              ),
            ];
          },
        ),
      ),
    );
  }

  sectionTitle(String title) {
    return ListTile(
      title: Text(title, style: AppFonts.primaryFontBlackColor),
    );
  }

  sectionContainer(Widget widget) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: AppColors.whiteColor,
      ),
      child: widget,
    );
  }

  sectionSubWidget({required String icon, required String title, required Widget screen}) {
    return ListTile(
      leading: Image.asset(icon, height: 25, width: 25.0),
      title: Text(title, style: AppFonts.primaryFontBlackColor),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.greyColor, size: 15.0),
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
      },
    );
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumber = packageInfo.version;
    setState(() {});
  }

  buildLogoutBtn() {
    return ListTile(
      leading: Icon(Icons.logout, color: AppColors.redColor, size: 30.0),
      title: Text(selectedLang[AppLangAssets.logout]!, style: AppFonts.primaryFontRedColor),
      onTap: () {
        showCustomDialog(
          context,
          dialogTitle: selectedLang[AppLangAssets.logout]!,
          dialogBody: Text(selectedLang[AppLangAssets.areUSureLogout]!, style: AppFonts.subFontGreyColor),
          dialogSize: Size(200, 300),
          dialogActions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBtn(
                widget: Text(selectedLang[AppLangAssets.no]!, style: AppFonts.miniFontGreenColor),
                size: Size(100.0, 30.0),
                color: AppColors.ofWhiteColor,
                radius: 15.0,
                onPress: () {
                  Navigator.pop(context);
                }
              ),
              CustomBtn(
                widget: Text(selectedLang[AppLangAssets.yes]!, style: AppFonts.miniFontWhiteColor),
                size: Size(100.0, 30.0),
                color: AppColors.redColor,
                radius: 15.0,
                onPress: () {}
              ),
            ],
          )
        );
      },
    );
  }
}