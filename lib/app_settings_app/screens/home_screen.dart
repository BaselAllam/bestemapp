import 'package:bestemapp/car_app/screens/car_search_result_screen.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_theme/app_fonts.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/car_app/widgets/sell_btn.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.ofWhiteColor,
        title: Text('${selectedLang[AppLangAssets.homeWlcTitle]} Bassel Allam 👋', style: AppFonts.primaryFontBlackColor),
        actions: [SellBtn(), NotificationButton()],
      ),
      body: ListView(
        children: [
          buildAdsSection(),
          sectionTitle('${selectedLang[AppLangAssets.popular]} ', true, () {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => SearchResultsScreen(screenTitle: selectedLang[AppLangAssets.popular]!)));
          }),
          buildItemsSection(),
          sectionTitle('${selectedLang[AppLangAssets.recentlyAdded]} ', true, () {
            Navigator.push(context, CupertinoPageRoute(builder: (_) => SearchResultsScreen(screenTitle: selectedLang[AppLangAssets.recentlyAdded]!)));
          }),
          buildItemsSection(),
        ],
      ),
    );
  }

  sectionTitle(String title, bool showSeeMore, Function onTap) {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) {
        return ListTile(
          title: Text(title, style: AppFonts.primaryFontBlackColor),
          trailing: showSeeMore ? Text(selectedLang[AppLangAssets.seeMore]!, style: AppFonts.miniFontGreyColor) : SizedBox(),
          onTap: !showSeeMore ? () {} : () {
            onTap();
          },
        );
      },
    );
  }

  buildAdsSection() {
    return Container(
      height: 500,
      margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&h=1200&fit=crop',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    _buildTab('All', 0),
                    const SizedBox(width: 32),
                    _buildTab('New', 1),
                    const SizedBox(width: 32),
                    _buildTab('Used', 2),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdown('Any Makes'),
                const SizedBox(height: 16),
                _buildDropdown('Any Models'),
                const SizedBox(height: 16),
                _buildDropdown('Prices: All Prices'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Search Cars',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 24),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        itemBuilder: (context, index) => CarAdWidget(car: {
      'id': '1',
      'title': '2023 Toyota Camry SE',
      'price': 28500,
      'year': 2023,
      'mileage': 12500,
      'location': 'Los Angeles, CA',
      'transmission': 'Automatic',
      'fuelType': 'Hybrid',
      'image': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800',
      'condition': 'Like New',
      'seller': 'Premium Dealer',
      'isFeatured': true,
      'isVerified': true,
    },),
      ),
    );
  }
}