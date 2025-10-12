import 'package:bestemapp/car_app/widgets/car_ad_widget.dart';
import 'package:bestemapp/car_app/widgets/filter_widget.dart';
import 'package:bestemapp/car_app/widgets/sort_widget.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  final String screenTitle;
  SearchResultsScreen({required this.screenTitle});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  CarSortOption? _currentSort;

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
    
  }
  String _sortBy = 'Relevant';
  
  final List<Map<String, dynamic>> _cars = [
    {
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
    },
    {
      'id': '2',
      'title': '2022 Honda Accord Sport',
      'price': 26900,
      'year': 2022,
      'mileage': 18200,
      'location': 'San Diego, CA',
      'transmission': 'Automatic',
      'fuelType': 'Gasoline',
      'image': 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=800',
      'condition': 'Excellent',
      'seller': 'Private Seller',
      'isFeatured': false,
      'isVerified': true,
    },
    {
      'id': '3',
      'title': '2021 Tesla Model 3 Long Range',
      'price': 42000,
      'year': 2021,
      'mileage': 22000,
      'location': 'San Francisco, CA',
      'transmission': 'Automatic',
      'fuelType': 'Electric',
      'image': 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=800',
      'condition': 'Excellent',
      'seller': 'Certified Dealer',
      'isFeatured': true,
      'isVerified': true,
    },
    {
      'id': '4',
      'title': '2023 BMW 3 Series 330i',
      'price': 45500,
      'year': 2023,
      'mileage': 8500,
      'location': 'Sacramento, CA',
      'transmission': 'Automatic',
      'fuelType': 'Gasoline',
      'image': 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800',
      'condition': 'Like New',
      'seller': 'Premium Dealer',
      'isFeatured': false,
      'isVerified': true,
    },
    {
      'id': '5',
      'title': '2022 Ford Mustang GT',
      'price': 38900,
      'year': 2022,
      'mileage': 15000,
      'location': 'Fresno, CA',
      'transmission': 'Manual',
      'fuelType': 'Gasoline',
      'image': 'https://images.unsplash.com/photo-1584345604476-8ec5f5b8c4b0?w=800',
      'condition': 'Excellent',
      'seller': 'Private Seller',
      'isFeatured': false,
      'isVerified': false,
    },
    {
      'id': '6',
      'title': '2021 Audi A4 Premium Plus',
      'price': 37200,
      'year': 2021,
      'mileage': 24000,
      'location': 'Oakland, CA',
      'transmission': 'Automatic',
      'fuelType': 'Gasoline',
      'image': 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800',
      'condition': 'Good',
      'seller': 'Certified Dealer',
      'isFeatured': false,
      'isVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text('Search Results', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildResultsHeader(),
          // Expanded(
          //   child: ListView.builder(
          //     padding: const EdgeInsets.all(5),
          //     itemCount: _cars.length,
          //     itemBuilder: (context, index) {
          //       return CarAdWidget(car: _cars[index]);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_cars.length} cars found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Row(
              children: [
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.tune, color: Colors.blue[700]),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showSortOptions(),
            child: Row(
              children: [
                Text(
                  'Sort: $_sortBy',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSortOption('Relevant'),
              _buildSortOption('Price: Low to High'),
              _buildSortOption('Price: High to Low'),
              _buildSortOption('Year: Newest'),
              _buildSortOption('Year: Oldest'),
              _buildSortOption('Mileage: Low to High'),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = _sortBy == option;
    return ListTile(
      title: Text(
        option,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.blue[700] : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Colors.blue[700])
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
        },
      ),
    );
  }
}