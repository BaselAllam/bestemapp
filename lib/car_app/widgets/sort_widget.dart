import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';

enum CarSortOption {
  priceAsc,
  priceDesc,
  yearNewest,
  yearOldest,
  mileageLow,
  mileageHigh,
  featured,
  newest,
}

extension CarSortOptionExtension on CarSortOption {
  String get label {
    switch (this) {
      case CarSortOption.priceAsc:
        return 'Price: Low to High';
      case CarSortOption.priceDesc:
        return 'Price: High to Low';
      case CarSortOption.yearNewest:
        return 'Year: Newest First';
      case CarSortOption.yearOldest:
        return 'Year: Oldest First';
      case CarSortOption.mileageLow:
        return 'Mileage: Low to High';
      case CarSortOption.mileageHigh:
        return 'Mileage: High to Low';
      case CarSortOption.featured:
        return 'Featured';
      case CarSortOption.newest:
        return 'Newly Listed';
    }
  }

  IconData get icon {
    switch (this) {
      case CarSortOption.priceAsc:
        return Icons.arrow_upward;
      case CarSortOption.priceDesc:
        return Icons.arrow_downward;
      case CarSortOption.yearNewest:
        return Icons.calendar_today;
      case CarSortOption.yearOldest:
        return Icons.calendar_month;
      case CarSortOption.mileageLow:
        return Icons.speed;
      case CarSortOption.mileageHigh:
        return Icons.speed;
      case CarSortOption.featured:
        return Icons.star;
      case CarSortOption.newest:
        return Icons.new_releases;
    }
  }
}

class CarSortBottomSheet extends StatefulWidget {
  final CarSortOption? currentSort;
  final bool showMileageOptions;
  final Function(CarSortOption) onSortSelected;

  const CarSortBottomSheet({
    Key? key,
    this.currentSort,
    this.showMileageOptions = true,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  State<CarSortBottomSheet> createState() => _CarSortBottomSheetState();

  static Future<CarSortOption?> show({
    required BuildContext context,
    CarSortOption? currentSort,
    bool showMileageOptions = true,
    Function(CarSortOption)? onSortChanged,
  }) {
    return showModalBottomSheet<CarSortOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarSortBottomSheet(
        currentSort: currentSort,
        showMileageOptions: showMileageOptions,
        onSortSelected: onSortChanged ?? (sort) {},
      ),
    );
  }
}

class _CarSortBottomSheetState extends State<CarSortBottomSheet> {
  late CarSortOption? _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      CarSortOption.featured,
      CarSortOption.newest,
      CarSortOption.priceAsc,
      CarSortOption.priceDesc,
      CarSortOption.yearNewest,
      CarSortOption.yearOldest,
      if (widget.showMileageOptions) ...[
        CarSortOption.mileageLow,
        CarSortOption.mileageHigh,
      ],
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),

          // Sort options
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortOptions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              final isSelected = _selectedSort == option;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedSort = option;
                    });
                    widget.onSortSelected(option);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? AppColors.primaryColor : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}