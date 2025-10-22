import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/car_app/widgets/filter_widget.dart';
import 'package:bestemapp/car_app/widgets/sort_widget.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/error_widget.dart';
import 'package:bestemapp/shared/shared_widgets/loading_spinner.dart';
import 'package:bestemapp/shared/shared_widgets/no_result_found.dart';
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
  CarSortOption? _currentSort;
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;


  void _showSortBottomSheet() async {
    final result = await CarSortBottomSheet.show(
      context: context,
      currentSort: _currentSort,
      showMileageOptions: true,
    );

    if (result != null) {
      setState(() {
        _currentSort = result;
      });
      _applySorting(result);
    }
  }

  void _applySorting(CarSortOption sort) {
    // Apply sorting logic
  }

  String _sortBy = 'Relevant';

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_activeFilters.isEmpty ? 1 : 61),
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                height: 1,
              ),
              if (_activeFilters.isNotEmpty) _buildActiveFiltersBar(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildControlBar(),
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.ads.isEmpty)
            _buildEmptyState()
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: BlocBuilder<CarCubit, CarStates>(
                  builder: (context, state) {
                    if (state is SearchCarAdsLoadingState) {
                      return Center(child: CustomLoadingSpinner());
                    } else if (state is SearchCarAdsErrorState) {
                      return Center(child: CustomErrorWidget());
                    } else if (BlocProvider.of<CarCubit>(context).searchCarAdsResult.isEmpty) {
                      return Center(child: NoResultFoundWidget());
                    } else {
                      return _buildListView();
                    }
                  }
                )
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
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
                  '${widget.ads.length} ${widget.ads.length == 1 ? 'car' : 'cars'} found',
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
            label: 'Filter',
            badge: _getActiveFilterCount(),
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

  int _getActiveFilterCount() {
    int count = 0;
    _activeFilters.forEach((key, value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          count++;
        } else if (value is Map && value.isNotEmpty) {
          count++;
        } else if (value is String && value.isNotEmpty) {
          count++;
        } else if (value is num) {
          count++;
        }
      }
    });
    return count;
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    int? badge,
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
                  if (badge != null && badge > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badge > 9 ? '9+' : '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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

  Widget _buildActiveFiltersBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._buildFilterChips(),
                  if (_getActiveFilterCount() > 0) 
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: _buildClearAllChip(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    List<Widget> chips = [];
    
    _activeFilters.forEach((key, value) {
      // Only add chip if the filter has a valid value
      if (_isValidFilterValue(value)) {
        String displayValue = _formatFilterValue(key, value);
        chips.add(
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildFilterChip(key, displayValue),
          ),
        );
      }
    });
    
    return chips;
  }

  bool _isValidFilterValue(dynamic value) {
    if (value == null) return false;
    
    if (value is String) {
      return value.isNotEmpty;
    } else if (value is List) {
      return value.isNotEmpty;
    } else if (value is Map) {
      return value.isNotEmpty && 
             (value.containsKey('min') || value.containsKey('max'));
    } else if (value is num) {
      return true;
    }
    
    return false;
  }

  Widget _buildFilterChip(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFilterIcon(key),
            size: 14,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeFilter(key),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearAllChip() {
    return GestureDetector(
      onTap: _clearAllFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.clear_all_rounded,
              size: 14,
              color: Colors.red[700],
            ),
            const SizedBox(width: 6),
            Text(
              'Clear All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFilterIcon(String key) {
    switch (key.toLowerCase()) {
      case 'price':
      case 'pricemin':
      case 'pricemax':
        return Icons.attach_money_rounded;
      case 'year':
      case 'yearmin':
      case 'yearmax':
        return Icons.calendar_today_rounded;
      case 'mileage':
      case 'mileagemin':
      case 'mileagemax':
        return Icons.speed_rounded;
      case 'brand':
      case 'make':
      case 'model':
        return Icons.directions_car_rounded;
      case 'location':
      case 'city':
        return Icons.location_on_rounded;
      case 'fueltype':
      case 'fuel':
        return Icons.local_gas_station_rounded;
      case 'transmission':
        return Icons.settings_rounded;
      case 'condition':
        return Icons.star_rounded;
      case 'color':
        return Icons.palette_rounded;
      case 'bodytype':
        return Icons.drive_eta_rounded;
      default:
        return Icons.filter_alt_rounded;
    }
  }

  String _formatFilterValue(String key, dynamic value) {
    // Handle list values
    if (value is List && value.isNotEmpty) {
      if (value.length == 1) {
        return value[0].toString();
      } else if (value.length == 2) {
        return '${value[0]}, ${value[1]}';
      } else {
        return '${value[0]} +${value.length - 1} more';
      }
    }
    
    // Handle range values (Map with min/max)
    if (value is Map) {
      final hasMin = value.containsKey('min') && value['min'] != null;
      final hasMax = value.containsKey('max') && value['max'] != null;
      
      switch (key.toLowerCase()) {
        case 'price':
          if (hasMin && hasMax) {
            return '\$${value['min']} - \$${value['max']}';
          } else if (hasMin) {
            return 'From \$${value['min']}';
          } else if (hasMax) {
            return 'Up to \$${value['max']}';
          }
          break;
        case 'year':
          if (hasMin && hasMax) {
            return '${value['min']} - ${value['max']}';
          } else if (hasMin) {
            return 'From ${value['min']}';
          } else if (hasMax) {
            return 'Up to ${value['max']}';
          }
          break;
        case 'mileage':
          if (hasMin && hasMax) {
            return '${value['min']}k - ${value['max']}k mi';
          } else if (hasMin) {
            return 'From ${value['min']}k mi';
          } else if (hasMax) {
            return 'Up to ${value['max']}k mi';
          }
          break;
      }
    }
    
    // Handle simple string/number values
    return value.toString();
  }

  void _removeFilter(String key) {
    setState(() {
      _activeFilters.remove(key);
    });
    // Reapply search with updated filters
    _applyFilters();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
    // Reapply search with no filters
    _applyFilters();
  }

  void _applyFilters() {
    // Apply the current filters to the search results
    // This would typically involve calling your API or filtering your data
    print('Applying filters: $_activeFilters');
  }

  String _getSortLabel() {
    if (_sortBy == 'Relevant') return 'Sort';
    if (_sortBy.contains(':')) return _sortBy.split(':')[0];
    return _sortBy;
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.ads.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: CarAdWidget(carAdModel: widget.ads[index]),
        );
      },
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
                'No cars found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Try adjusting your filters or search criteria\nto find what you\'re looking for',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _clearAllFilters,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Clear All Filters'),
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

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
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
                        const Text(
                          'Sort By',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSortOption('Relevant', Icons.stars_rounded),
                    _buildSortOption('Price: Low to High', Icons.arrow_upward_rounded),
                    _buildSortOption('Price: High to Low', Icons.arrow_downward_rounded),
                    _buildSortOption('Year: Newest', Icons.new_releases_rounded),
                    _buildSortOption('Year: Oldest', Icons.history_rounded),
                    _buildSortOption('Mileage: Low to High', Icons.speed_rounded),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String option, IconData icon) {
    final isSelected = _sortBy == option;
    return ListTile(
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
        setState(() {
          _sortBy = option;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarFilterBottomSheet(
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }
}