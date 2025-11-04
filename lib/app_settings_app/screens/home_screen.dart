import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/app_settings_app/logic/country_model.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/car_app/screens/car_search_result_screen.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/notification_btn.dart';
import 'package:bestemapp/car_app/widgets/sell_btn.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  final PageController _carouselController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    Future.delayed(const Duration(seconds: 3), _autoScrollCarousel);
  }

  void _autoScrollCarousel() {
    if (!mounted) return;
    
    Future.delayed(const Duration(seconds: 3), () {
      if (_carouselController.hasClients) {
        int nextPage = (_currentCarouselIndex + 1) % BlocProvider.of<AppSettingsCubit>(context).landingBanners.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _autoScrollCarousel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is LandingCarAdsErrorState) {
            return Center(child: CustomErrorWidget(errorMessage: state.errorMsg, onRetry: () => BlocProvider.of<CarCubit>(context).getCarsLanding()));
          } else if (state is LandingCarAdsSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget(errorMessage: selectedLang[AppLangAssets.someThingWentWrong], onRetry: () => BlocProvider.of<CarCubit>(context).getCarsLanding()));
          } else {
            return CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildOffersCarousel(),
                      const SizedBox(height: 24),
                      _buildHeroSearchSection(),
                      const SizedBox(height: 24),
                      _buildQuickStats(BlocProvider.of<CarCubit>(context).carAdsCount, BlocProvider.of<CarCubit>(context).usersCount),
                      const SizedBox(height: 32),
                      _buildPopularBrands(),
                      const SizedBox(height: 24),
                      _buildPopularSection(),
                      const SizedBox(height: 24),
                      _buildRecentlyAddedSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3B82F6),
                const Color(0xFF2563EB),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      '${selectedLang[AppLangAssets.homeWlcTitle]} 👋',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      BlocProvider.of<UserCubit>(context).userModel!.firstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        SellBtn(),
        NotificationButton(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildOffersCarousel() {
    return BlocBuilder<AppSettingsCubit, AppSettingsStates>(
      builder: (context, state) {
        if (state is GetLandingBannersLoadingState) {
          return Center(child: CustomLoadingSpinner());
        } else if (state is GetLandingBannersErrorState || state is GetLandingBannersSomeThingWentWrongState) {
          return Center(child: CustomErrorWidget());
        } else {
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _carouselController,
                onPageChanged: (index) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
                itemCount: BlocProvider.of<AppSettingsCubit>(context).landingBanners.length,
                itemBuilder: (context, index) {
                  final offer = BlocProvider.of<AppSettingsCubit>(context).landingBanners[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            offer.bannerImg,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            top: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    selectedLang[AppLangAssets.limitedTime]!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  BlocProvider.of<AppSettingsCubit>(context).selectedLangOption == LanguageOption.ar ? offer.bannerTitleAr : offer.bannerTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  BlocProvider.of<AppSettingsCubit>(context).selectedLangOption == LanguageOption.ar ? offer.bannerDescriptionAr : offer.bannerDescription,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                BlocProvider.of<AppSettingsCubit>(context).landingBanners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentCarouselIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentCarouselIndex == index
                        ? const Color(0xFF3B82F6)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
        }
      }
    );
  }

  Widget _buildHeroSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              height: 490,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: BlocBuilder<CarCubit, CarStates>(
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedLang[AppLangAssets.findUrDreamCar]!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedLang[AppLangAssets.searchFromThousands]!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildTab('All', 0),
                          const SizedBox(width: 32),
                          _buildTab('New', 1),
                          const SizedBox(width: 32),
                          _buildTab('Used', 2),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<CarMakeModel>(
                        dropdownColor: AppColors.whiteColor,
                        value: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_make_id.name],
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 22),
                          prefixIcon: Icon(Icons.car_crash, color: Colors.grey[700], size: 20),
                          hintText: selectedLang[AppLangAssets.selectBrand]!,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        items: BlocProvider.of<CarCubit>(context).carMakes.map((item) {
                          return DropdownMenuItem(value: item, child: Row(
                            children: [
                              Image.network(item.makeLogo, height: 20, width: 20),
                              SizedBox(width: 10),
                              Text(item.makeName),
                            ],
                          ));
                        }).toList(),
                        onChanged: (value) {
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.car_make_id, value);
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.car_model_id, null);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<CarMakeModelModel>(
                        dropdownColor: AppColors.whiteColor,
                        value: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_model_id.name] ?? null,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 22),
                          prefixIcon: Icon(Icons.car_crash, color: Colors.grey[700], size: 20),
                          hintText: selectedLang[AppLangAssets.selectBrand]!,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        items:BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_make_id.name] == null ?
                        [] : <DropdownMenuItem<CarMakeModelModel>>[
                          for (var item in BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_make_id.name]!.models)
                          DropdownMenuItem(value: item, child: Text(item.modelName))
                        ],
                        onChanged: (value) {
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.car_model_id, value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<CityModel>(
                        dropdownColor: AppColors.whiteColor,
                        value: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_city_id.name],
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 22),
                          prefixIcon: Icon(Icons.location_city, color: Colors.grey[700], size: 20),
                          hintText: selectedLang[AppLangAssets.selectCity]!,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        items: BlocProvider.of<AppSettingsCubit>(context).countries[0].cities.map((item) {
                          return DropdownMenuItem(value: item, child: Text(item.cityName));
                        }).toList(),
                        onChanged: (value) {
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.ad_city_id, value);
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.ad_area_id, null);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<AreaModel>(
                        dropdownColor: AppColors.whiteColor,
                        value: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_area_id.name] ?? null,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 22),
                          prefixIcon: Icon(Icons.location_city, color: Colors.grey[700], size: 20),
                          hintText: selectedLang[AppLangAssets.selectCity]!,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                        ),
                        items: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_city_id.name] == null ? [] : <DropdownMenuItem<AreaModel>>[
                          for (var item in BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_city_id.name]!.areas)
                          DropdownMenuItem(value: item, child: Text(item.areaName))
                        ],
                        onChanged: (value) {
                          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.ad_area_id, value);
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_city_id.name] == null) {
                              Toaster.show(context, message: selectedLang[AppLangAssets.selectAreaFirst]!, type: ToasterType.error, position: ToasterPosition.top);
                              return;
                            }
                            BlocProvider.of<CarCubit>(context).searchCarAds();
                            Navigator.push(context, CupertinoPageRoute(builder: (_) => SearchResultsScreen(
                              screenTitle: selectedLang[AppLangAssets.searchResult]!,
                              ads: BlocProvider.of<CarCubit>(context).searchCarAdsResult,
                              ),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.ad_city_id.name] == null ? AppColors.greyColor.withOpacity(0.5) : AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            shadowColor: AppColors.primaryColor.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: Colors.white, size: 24),
                              SizedBox(width: 12),
                              Text(
                                selectedLang[AppLangAssets.search]!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(int carCount, int userCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.directions_car,
              count: '${carCount}+',
              label: selectedLang[AppLangAssets.ads]!,
              color: const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.verified,
              count: '100%',
              label: selectedLang[AppLangAssets.verified]!,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.people,
              count: '${userCount}+',
              label: selectedLang[AppLangAssets.users]!,
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      children: [
        _buildSectionHeader(
          '${selectedLang[AppLangAssets.popular]}',
          Icons.trending_up,
          () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => SearchResultsScreen(
                  screenTitle: selectedLang[AppLangAssets.popular]!,
                  ads: BlocProvider.of<CarCubit>(context).landingCarAdsResult['popular']!,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        buildItemsSection('popular'),
      ],
    );
  }

  Widget _buildRecentlyAddedSection() {
    return Column(
      children: [
        _buildSectionHeader(
          '${selectedLang[AppLangAssets.recentlyAdded]}',
          Icons.fiber_new,
          () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => SearchResultsScreen(
                  screenTitle: selectedLang[AppLangAssets.recentlyAdded]!,
                  ads: BlocProvider.of<CarCubit>(context).landingCarAdsResult['recently_added']!,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        buildItemsSection('recently_added'),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onTap,
            child: Row(
              children: [
                Text(
                  selectedLang[AppLangAssets.seeMore]!,
                  style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF3B82F6),
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBrands() {
  final List<CarMakeModel> brands = [];
  for (CarMakeModel i in BlocProvider.of<CarCubit>(context).carMakes) {
    if (i.isPopular) {
      brands.add(i);
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          selectedLang[AppLangAssets.popularBrands]!,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 120,
        child: BlocBuilder<CarCubit, CarStates>(
          builder: (context, state) {
            if (state is GetCarMakesLoadingState) {
              return Center(child: CustomLoadingSpinner());
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(brand.makeLogo, height: 50, width: 100,),
                              const SizedBox(height: 8),
                              Text(
                                brand.makeName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        ),
      ),
    ],
  );
}

  Widget _buildTab(String label, int index) {
    return BlocBuilder<CarCubit, CarStates>(
      builder: (context, state) {
      return GestureDetector(
        onTap: () {
          if (label == 'All') {
            BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.car_condition, null);
          } else {
            BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.car_condition, label.toLowerCase());
          }
        },
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_condition.name] == label.toLowerCase() ? const Color(0xFF3B82F6) : Colors.grey[600],
                fontSize: 16,
                fontWeight: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_condition.name] == label.toLowerCase() ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: BlocProvider.of<CarCubit>(context).searchCarParams[SearchCarParamsKeys.car_condition.name] == label.toLowerCase() ? 40 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      );
      }
    );
  }

  Widget buildItemsSection(String sectionTitle) {
    return Container(
      height: 500.0,
      margin: const EdgeInsets.all(5),
      child: BlocBuilder<CarCubit, CarStates>(
        builder: (context, state) {
          if (state is LandingCarAdsErrorState || state is LandingCarAdsSomeThingWentWrongState) {
            return Center(child: CustomErrorWidget());
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: BlocProvider.of<CarCubit>(context).landingCarAdsResult[sectionTitle]!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CarAdWidget(
                  carAdModel: BlocProvider.of<CarCubit>(context).landingCarAdsResult[sectionTitle]![index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}