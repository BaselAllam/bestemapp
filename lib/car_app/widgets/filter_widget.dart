import 'package:flutter/material.dart';

class CarFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const CarFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<CarFilterBottomSheet> createState() => _CarFilterBottomSheetState();
}

class _CarFilterBottomSheetState extends State<CarFilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Filter States
  String _condition = 'all'; // all, new, used
  RangeValues _priceRange = RangeValues(0, 100000);
  RangeValues _yearRange = RangeValues(2000, 2025);
  RangeValues _mileageRange = RangeValues(0, 200000);
  
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedBodyType;
  String? _selectedTransmission;
  String? _selectedFuelType;
  String? _selectedColor;
  
  List<String> _selectedFeatures = [];
  
  // Data Lists
  final List<String> _makes = [
    'Any Make', 'Toyota', 'Honda', 'BMW', 'Mercedes-Benz', 'Ford', 
    'Chevrolet', 'Nissan', 'Hyundai', 'Volkswagen', 'Audi', 'Lexus',
    'Mazda', 'Kia', 'Subaru', 'Jeep', 'Tesla', 'Porsche'
  ];
  
  final List<String> _bodyTypes = [
    'Any Body Type', 'Sedan', 'SUV', 'Truck', 'Coupe', 'Hatchback', 
    'Convertible', 'Van', 'Wagon', 'Minivan', 'Crossover'
  ];
  
  final List<String> _transmissions = [
    'Any Transmission', 'Automatic', 'Manual', 'CVT', 'Semi-Automatic'
  ];
  
  final List<String> _fuelTypes = [
    'Any Fuel Type', 'Gasoline', 'Diesel', 'Electric', 'Hybrid', 
    'Plug-in Hybrid', 'Hydrogen'
  ];
  
  final List<String> _colors = [
    'Any Color', 'Black', 'White', 'Silver', 'Gray', 'Red', 'Blue', 
    'Green', 'Yellow', 'Orange', 'Brown', 'Gold', 'Beige'
  ];
  
  final List<String> _features = [
    'Sunroof', 'Leather Seats', 'Navigation System', 'Backup Camera',
    'Blind Spot Monitor', 'Lane Departure Warning', 'Cruise Control',
    'Heated Seats', 'Cooled Seats', 'All-Wheel Drive', 'Apple CarPlay',
    'Android Auto', 'Bluetooth', 'USB Port', 'Parking Sensors',
    'Keyless Entry', 'Push Start', 'Premium Audio', 'Third Row Seats'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedMake = _makes[0];
    _selectedBodyType = _bodyTypes[0];
    _selectedTransmission = _transmissions[0];
    _selectedFuelType = _fuelTypes[0];
    _selectedColor = _colors[0];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _condition = 'all';
      _priceRange = RangeValues(0, 100000);
      _yearRange = RangeValues(2000, 2025);
      _mileageRange = RangeValues(0, 200000);
      _selectedMake = _makes[0];
      _selectedModel = null;
      _selectedBodyType = _bodyTypes[0];
      _selectedTransmission = _transmissions[0];
      _selectedFuelType = _fuelTypes[0];
      _selectedColor = _colors[0];
      _selectedFeatures = [];
    });
  }

  void _applyFilters() {
    final filters = {
      'condition': _condition,
      'priceMin': _priceRange.start,
      'priceMax': _priceRange.end,
      'yearMin': _yearRange.start.toInt(),
      'yearMax': _yearRange.end.toInt(),
      'mileageMin': _mileageRange.start.toInt(),
      'mileageMax': _mileageRange.end.toInt(),
      'make': _selectedMake,
      'model': _selectedModel,
      'bodyType': _selectedBodyType,
      'transmission': _selectedTransmission,
      'fuelType': _selectedFuelType,
      'color': _selectedColor,
      'features': _selectedFeatures,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicFilters(),
                _buildDetailedFilters(),
                _buildFeaturesFilters(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Advanced Filters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF3B82F6),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color(0xFF3B82F6),
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: 'Basic'),
          Tab(text: 'Details'),
          Tab(text: 'Features'),
        ],
      ),
    );
  }

  Widget _buildBasicFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Condition'),
          SizedBox(height: 12),
          _buildConditionSelector(),
          
          SizedBox(height: 32),
          _buildSectionTitle('Price Range'),
          _buildRangeSlider(
            values: _priceRange,
            min: 0,
            max: 100000,
            divisions: 100,
            onChanged: (values) => setState(() => _priceRange = values),
            formatter: (value) => '\$${(value / 1000).toStringAsFixed(0)}K',
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle('Year Range'),
          _buildRangeSlider(
            values: _yearRange,
            min: 2000,
            max: 2025,
            divisions: 25,
            onChanged: (values) => setState(() => _yearRange = values),
            formatter: (value) => value.toInt().toString(),
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle('Mileage Range (miles)'),
          _buildRangeSlider(
            values: _mileageRange,
            min: 0,
            max: 200000,
            divisions: 100,
            onChanged: (values) => setState(() => _mileageRange = values),
            formatter: (value) => '${(value / 1000).toStringAsFixed(0)}K',
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle('Make'),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedMake!,
            items: _makes,
            onChanged: (value) => setState(() => _selectedMake = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Body Type'),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedBodyType!,
            items: _bodyTypes,
            onChanged: (value) => setState(() => _selectedBodyType = value),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Transmission'),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedTransmission!,
            items: _transmissions,
            onChanged: (value) => setState(() => _selectedTransmission = value),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Fuel Type'),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedFuelType!,
            items: _fuelTypes,
            onChanged: (value) => setState(() => _selectedFuelType = value),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Exterior Color'),
          SizedBox(height: 8),
          _buildColorGrid(),
          
          SizedBox(height: 24),
          _buildSectionTitle('Number of Doors'),
          SizedBox(height: 12),
          _buildChipSelection(
            options: ['2 Door', '4 Door', '5 Door'],
            selectedOption: null,
            onSelected: (value) {},
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle('Drivetrain'),
          SizedBox(height: 12),
          _buildChipSelection(
            options: ['FWD', 'RWD', 'AWD', '4WD'],
            selectedOption: null,
            onSelected: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Select Features'),
          SizedBox(height: 8),
          Text(
            'Choose all the features you want in your car',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _features.map((feature) {
              final isSelected = _selectedFeatures.contains(feature);
              return FilterChip(
                label: Text(feature),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFeatures.add(feature);
                    } else {
                      _selectedFeatures.remove(feature);
                    }
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Color(0xFF3B82F6).withOpacity(0.2),
                checkmarkColor: Color(0xFF3B82F6),
                labelStyle: TextStyle(
                  color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildConditionCard('All', 'all', Icons.directions_car),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildConditionCard('New', 'new', Icons.new_releases),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildConditionCard('Used', 'used', Icons.time_to_leave),
        ),
      ],
    );
  }

  Widget _buildConditionCard(String label, String value, IconData icon) {
    final isSelected = _condition == value;
    return InkWell(
      onTap: () => setState(() => _condition = value),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildRangeSlider({
    required RangeValues values,
    required double min,
    required double max,
    required int divisions,
    required Function(RangeValues) onChanged,
    required String Function(double) formatter,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formatter(values.start),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text('to', style: TextStyle(color: Colors.grey)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                formatter(values.end),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Color(0xFF3B82F6),
          inactiveColor: Colors.grey.shade300,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColorGrid() {
    final colorMap = {
      'Any Color': null,
      'Black': Colors.black,
      'White': Colors.white,
      'Silver': Colors.grey.shade400,
      'Gray': Colors.grey.shade700,
      'Red': Colors.red,
      'Blue': Colors.blue,
      'Green': Colors.green,
      'Yellow': Colors.yellow.shade700,
      'Orange': Colors.orange,
      'Brown': Colors.brown,
      'Gold': Colors.amber.shade700,
      'Beige': Colors.brown.shade200,
    };

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colorMap.entries.map((entry) {
        final isSelected = _selectedColor == entry.key;
        return InkWell(
          onTap: () => setState(() => _selectedColor = entry.key),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: entry.value ?? Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: entry.value == null
                ? Center(
                    child: Icon(Icons.palette, color: Colors.grey.shade600),
                  )
                : isSelected
                    ? Icon(Icons.check, color: Colors.white)
                    : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipSelection({
    required List<String> options,
    required String? selectedOption,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOption == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) => onSelected(option),
          backgroundColor: Colors.grey.shade100,
          selectedColor: Color(0xFF3B82F6),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}