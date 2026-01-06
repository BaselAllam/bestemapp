import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/car_app/widgets/filter_widget.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsScreen extends StatefulWidget {
  final String screenTitle;
  List<CarAdModel> ads;
  SearchResultsScreen({required this.ads, required this.screenTitle});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {

  String _sortBy = 'Relevant';

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.screenTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: BlocBuilder<CarCubit, CarStates>(
        buildWhen: (previous, current) {
          return current is SearchCarAdsState;
        },
        builder: (context, state) {
          if (state is SearchCarAdsState) {
            final ads = state.results;
            if (state.isInitialLoading) {
              return const Center(child: CustomLoadingSpinner());
            }
            if (state.error != null && ads.isEmpty) {
              return Center(child: CustomErrorWidget(errorMessage: state.error));
            }
            return Column(
              children: [
                _buildControlBar(state),
                if (state.isSearchLoading && ads.isNotEmpty)
                  const LinearProgressIndicator(),
                if (ads.isEmpty)
                  _buildEmptyState()
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<CarCubit>().searchCarAds(isNewSearch: true);
                      },
                      child: _buildListView(state),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      )
    );
  }

  Widget _buildControlBar(SearchCarAdsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${widget.ads.length < 1 ? state.results.length : widget.ads.length} ${selectedLang[AppLangAssets.ads]!} ${selectedLang[AppLangAssets.found]!}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          _buildControlButton(
            icon: Icons.tune_rounded,
            label: selectedLang[AppLangAssets.filter]!,
            onTap: () => _showFilterBottomSheet(context),
          ),
          const SizedBox(width: 8),
          _buildControlButton(
            icon: Icons.sort_rounded,
            label: _getSortLabel(),
            onTap: _showSortOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 18, color: AppColors.primaryColor),
                ],
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSortLabel() {
    if (_sortBy.contains(':')) return _sortBy.split(':')[0];
    return _sortBy;
  }

  Widget _buildListView(SearchCarAdsState state) {
  final ads = state.results;
  return NotificationListener<ScrollNotification>(
    onNotification: (scrollInfo) {
      if (scrollInfo is ScrollUpdateNotification) {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        if (currentScroll >= maxScroll - 200 &&
            !state.isPaginating &&
            !state.isLastPage &&
            !state.isSearchLoading) {
          context.read<CarCubit>().searchCarAds();
        }
      }
      return false;
    },
    child: ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: ads.length + (state.isPaginating ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == ads.length && state.isPaginating) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CustomLoadingSpinner(),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CarAdWidget(
            carAdModel: ads[index],
          ),
        );
      },
    ),
  );
}

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                selectedLang[AppLangAssets.noCarsFound]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                selectedLang[AppLangAssets.tryAdjustFilter]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  BlocProvider.of<CarCubit>(context).clearSearchCarParams();
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(selectedLang[AppLangAssets.clearAllFilters]!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocBuilder<CarCubit, CarStates>(
          builder: (context, state) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sort_rounded, color: Colors.grey[700]),
                          const SizedBox(width: 12),
                          Text(
                            selectedLang[AppLangAssets.sort]!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSortOption(SearchCarParamsKeys.negative_price, selectedLang[AppLangAssets.priceHighToLow]!, Icons.arrow_upward_rounded),
                      _buildSortOption(SearchCarParamsKeys.price, selectedLang[AppLangAssets.priceLowToHigh]!, Icons.arrow_downward_rounded),
                      _buildSortOption(SearchCarParamsKeys.submitted_at, selectedLang[AppLangAssets.oldestFirst]!, Icons.new_releases_rounded),
                      _buildSortOption(SearchCarParamsKeys.negative_submitted_at, selectedLang[AppLangAssets.newestFirst]!, Icons.history_rounded),
                      _buildSortOption(SearchCarParamsKeys.kilometers, selectedLang[AppLangAssets.kiloMeteresLowToHigh]!, Icons.speed_rounded),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(SearchCarParamsKeys key, String option, IconData icon) {
    final isSelected = _sortBy == option;
    return BlocBuilder<CarCubit, CarStates>(
      builder: (context, state) => ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryColor : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          option,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primaryColor : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: AppColors.primaryColor)
            : null,
        onTap: () {
          BlocProvider.of<CarCubit>(context).setSearchCarParams(SearchCarParamsKeys.sort_by, key.name);
          setState(() {
            _sortBy = option;
          });
          BlocProvider.of<CarCubit>(context).resetNextPage();
          BlocProvider.of<CarCubit>(context).searchCarAds();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarFilterBottomSheet(),
    );
  }
}