import 'dart:io';
import 'package:bestemapp/app_settings_app/screens/faq_screen.dart';
import 'package:bestemapp/app_settings_app/screens/terms_conditions_screen.dart';
import 'package:bestemapp/car_app/screens/my_ads_screen.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/app_settings_app/screens/about_us_screen.dart';
import 'package:bestemapp/app_settings_app/screens/privacy_policy_screen.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/shared/shared_widgets/custom_btn.dart';
import 'package:bestemapp/shared/shared_widgets/custom_dialog.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/car_app/widgets/sell_btn.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/shared_widgets/url_launcher.dart';
import 'package:bestemapp/shared/utils/app_assets.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:bestemapp/user_app/screens/user_profile_screen.dart';
import 'package:bestemapp/user_app/screens/wallet_transactions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> social = [
    {'icon': AppAssets.webIcon, 'url': 'https://bestem.app'},
    {'icon': AppAssets.facebookIcon, 'url': 'https://www.facebook.com/profile.php?id=61582052996010'},
    {'icon': AppAssets.instagramIcon, 'url': 'https://www.instagram.com/bestem.app/?hl=en'},
    {'icon': AppAssets.linkedinIcon, 'url': 'https://www.linkedin.com/company/bestemapp/'}
  ];

  String versionNumber = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    getAppVersion();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        title: Text(
          selectedLang[AppLangAssets.navBarMore]!,
          style: AppFonts.primaryFontBlackColor,
        ),
        actions: [SellBtn(), NotificationButton()],
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsStates>(
        builder: (context, state) => FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: EdgeInsets.only(bottom: 20.0),
            children: [
              _buildProfileHeader(),
              SizedBox(height: 10),
              _buildProfileSection(),
              SizedBox(height: 20),
              _buildSettingsSection(),
              SizedBox(height: 20),
              _buildAppSection(),
              SizedBox(height: 20),
              _buildSocialSection(),
              SizedBox(height: 10),
              _buildVersionCard(),
              SizedBox(height: 10),
              _buildLogoutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<UserCubit, UserStates>(
      builder: (context, state) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Hero(
              tag: 'profile_pic',
              child: Container(
                height: 120.0,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: BlocProvider.of<UserCubit>(context).userModel!.profilePic.isEmpty
                          ? AssetImage(AppAssets.noPPIcon)
                          : NetworkImage(BlocProvider.of<UserCubit>(context).userModel!.profilePic),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              BlocProvider.of<UserCubit>(context).userModel!.firstName,
              style: AppFonts.primaryFontBlackColor.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              BlocProvider.of<UserCubit>(context).userModel!.email,
              style: AppFonts.subFontGreyColor.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildAnimatedSection(
      delay: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              selectedLang[AppLangAssets.profileData]!,
              style: AppFonts.primaryFontBlackColor.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildEnhancedListTile(
                  icon: AppAssets.personIcon,
                  title: selectedLang[AppLangAssets.myProfile]!,
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => UserProfileScreen())),
                ),
                _buildDivider(),
                _buildEnhancedListTile(
                  icon: AppAssets.myAdsIcon,
                  title: selectedLang[AppLangAssets.myAds]!,
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => MyAdsScreen())),
                ),
                _buildDivider(),
                _buildEnhancedListTile(
                  icon: AppAssets.walletIcon,
                  title: selectedLang[AppLangAssets.myWalletTransactions]!,
                  color: Colors.green,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => WalletTransactionsScreen())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return _buildAnimatedSection(
      delay: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              selectedLang[AppLangAssets.settingsSection]!,
              style: AppFonts.primaryFontBlackColor.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildLanguageTile(),
                _buildDivider(),
                _buildNotificationTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSection() {
    return _buildAnimatedSection(
      delay: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              selectedLang[AppLangAssets.appSection]!,
              style: AppFonts.primaryFontBlackColor.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildEnhancedListTile(
                  icon: AppAssets.aboutUsIcon,
                  title: selectedLang[AppLangAssets.aboutUs]!,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => AboutUsScreen())),
                ),
                _buildDivider(),
                _buildEnhancedListTile(
                  icon: AppAssets.faqIcon,
                  title: selectedLang[AppLangAssets.faq]!,
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => FAQScreen())),
                ),
                _buildDivider(),
                _buildEnhancedListTile(
                  icon: AppAssets.privacyPolicyIcon,
                  title: selectedLang[AppLangAssets.privacyPolicy]!,
                  color: Colors.indigo,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => PrivacyPolicyScreen())),
                ),
                _buildDivider(),
                _buildEnhancedListTile(
                  icon: AppAssets.termsConditionsIcon,
                  title: selectedLang[AppLangAssets.termAndConditions]!,
                  color: Colors.cyan,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => TermsAndConditionsScreen())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return _buildAnimatedSection(
      delay: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              selectedLang[AppLangAssets.followUs]!,
              style: AppFonts.primaryFontBlackColor.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < social.length; i++)
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (i * 100)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: _buildSocialButton(social[i]),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(Map<String, dynamic> socialItem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Image.asset(socialItem['icon']!, height: 30.0, width: 30.0),
        iconSize: 30.0,
        onPressed: () => openUrl(context, socialItem['url']!),
      ),
    );
  }

  Widget _buildVersionCard() {
    return _buildAnimatedSection(
      delay: 500,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(AppAssets.appVersionIcon, height: 25, width: 25.0),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLang[AppLangAssets.appVersion]!,
                    style: AppFonts.primaryFontBlackColor.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 3),
                  Text(
                    versionNumber,
                    style: AppFonts.subFontGreyColor.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final packageInfo = await PackageInfo.fromPlatform();
                final packageName = packageInfo.packageName;

                if (Platform.isAndroid) {
                  final playStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
                  if (await canLaunchUrl(playStoreUrl)) {
                    await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
                  }
                } else if (Platform.isIOS) {
                  final appStoreUrl = Uri.parse('https://apps.apple.com/app/id/YOUR_APP_ID');
                  if (await canLaunchUrl(appStoreUrl)) {
                    await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
                  }
                }
              },
              icon: Icon(Icons.upgrade, size: 18),
              label: Text(selectedLang[AppLangAssets.upgrade]!, style: AppFonts.miniFontWhiteColor),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return _buildAnimatedSection(
      delay: 600,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: AppColors.redColor.withOpacity(0.05),
          border: Border.all(color: AppColors.redColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.redColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.redColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.logout, color: AppColors.redColor, size: 24.0),
          ),
          title: Text(
            selectedLang[AppLangAssets.logout]!,
            style: AppFonts.primaryFontRedColor.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: AppColors.redColor, size: 18),
          onTap: () => _showLogoutDialog(),
        ),
      ),
    );
  }

  Widget _buildEnhancedListTile({
    required String icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(icon, height: 24, width: 24.0),
      ),
      title: Text(
        title,
        style: AppFonts.primaryFontBlackColor.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.greyColor, size: 16.0),
      onTap: onTap,
    );
  }

  Widget _buildLanguageTile() {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(AppAssets.langIcon, height: 24, width: 24.0),
        ),
        title: Text(
          selectedLang[AppLangAssets.changeLang]!,
          style: AppFonts.primaryFontBlackColor.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: PopupMenuButton(
          color: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.language, color: AppColors.primaryColor, size: 20.0),
          ),
          onSelected: (value) => _showLanguageDialog(value),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<LanguageOption>>[
              PopupMenuItem(
                child: Text(selectedLang[AppLangAssets.ar]!, style: AppFonts.subFontBlackColor),
                value: LanguageOption.ar,
              ),
              PopupMenuItem(
                child: Text(selectedLang[AppLangAssets.en]!, style: AppFonts.subFontBlackColor),
                value: LanguageOption.en,
              ),
            ];
          },
        ),
      ),
    );
  }

  Widget _buildNotificationTile() {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UpdateUserDataErrorState) {
          Toaster.show(
            context,
            message: state.errMsg,
            type: ToasterType.error,
            position: ToasterPosition.top,
          );
        } else if (state is UpdateUserDataSomeThingWentWrongState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.someThingWentWrong]!,
            type: ToasterType.error,
            position: ToasterPosition.top,
          );
        } else if (state is UpdateUserDataSuccessState) {
          Toaster.show(
            context,
            message: selectedLang[AppLangAssets.profileUpdatedSuccess]!,
            type: ToasterType.success,
            position: ToasterPosition.top,
          );
        }
      },
      builder: (context, state) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(AppAssets.acceptNotificationIcon, height: 24, width: 24.0),
        ),
        title: Text(
          selectedLang[AppLangAssets.acceptNotification]!,
          style: AppFonts.primaryFontBlackColor.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Switch(
          value: BlocProvider.of<UserCubit>(context).userModel!.isAcceptNotification,
          onChanged: (v) {
            BlocProvider.of<UserCubit>(context).updateAcceptNotification(v);
          },
          activeColor: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 20,
      color: AppColors.greyColor.withOpacity(0.2),
    );
  }

  Widget _buildAnimatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, double value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  void _showLanguageDialog(LanguageOption value) {
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
            color: AppColors.whiteColor,
            radius: 15.0,
            onPress: () => Navigator.pop(context),
          ),
          CustomBtn(
            widget: Text(selectedLang[AppLangAssets.yes]!, style: AppFonts.miniFontWhiteColor),
            size: Size(100.0, 30.0),
            color: AppColors.redColor,
            radius: 15.0,
            onPress: () async {
              await BlocProvider.of<AppSettingsCubit>(context).changeLanguage(value);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
            color: AppColors.whiteColor,
            radius: 15.0,
            onPress: () => Navigator.pop(context),
          ),
          BlocConsumer<UserCubit, UserStates>(
            listener: (context, state) {
              if (state is LogoutErrorState || state is LogoutSomeThingWentWrongState) {
                Toaster.show(
                  context,
                  message: selectedLang[AppLangAssets.someThingWentWrong]!,
                  type: ToasterType.error,
                  position: ToasterPosition.top,
                );
              }
            },
            builder: (context, state) => CustomBtn(
              widget: Text(
                state is LogoutLoadingState ? selectedLang[AppLangAssets.loading]! : selectedLang[AppLangAssets.yes]!,
                style: AppFonts.miniFontWhiteColor,
              ),
              size: Size(100.0, 30.0),
              color: AppColors.redColor,
              radius: 15.0,
              onPress: state is LogoutLoadingState ? () {} : () {
                BlocProvider.of<UserCubit>(context).logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionNumber = packageInfo.version;
    setState(() {});
  }
}