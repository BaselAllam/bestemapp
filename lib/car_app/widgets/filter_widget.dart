import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/color_model.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const CarFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<CarFilterBottomSheet> createState() => _CarFilterBottomSheetState();
}

class _CarFilterBottomSheetState extends State<CarFilterBottomSheet> {

  String _condition = 'all';
  
  final TextEditingController _priceMinController = TextEditingController(text: '0');
  final TextEditingController _priceMaxController = TextEditingController(text: '100000');
  final TextEditingController _yearMinController = TextEditingController(text: '2000');
  final TextEditingController _yearMaxController = TextEditingController();
  final TextEditingController _mileageMinController = TextEditingController(text: '0');
  final TextEditingController _mileageMaxController = TextEditingController(text: '200000');
  
  CarMakeModel? _selectedMake;
  CarMakeModelModel? _selectedModel;
  String? _selectedTransmission;
  String? _selectedFuelType;
  ColorModel? _selectedColor;
  
  List<String> _selectedFeatures = [];

  @override
  void initState() {
    super.initState();
    _selectedMake = BlocProvider.of<CarCubit>(context).carMakes[0];
    _selectedTransmission = BlocProvider.of<CarCubit>(context).transmissions[0];
    _selectedFuelType = BlocProvider.of<CarCubit>(context).fuelType[0];
    _selectedColor = BlocProvider.of<AppSettingsCubit>(context).colors[0];
    _yearMaxController.text = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _yearMinController.dispose();
    _yearMaxController.dispose();
    _mileageMinController.dispose();
    _mileageMaxController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _condition = 'all';
      _priceMinController.text = '0';
      _priceMaxController.text = '100000';
      _yearMinController.text = '2000';
      _yearMaxController.text = DateTime.now().year.toString();
      _mileageMinController.text = '0';
      _mileageMaxController.text = '200000';
      _selectedMake = BlocProvider.of<CarCubit>(context).carMakes[0];
      _selectedModel = null;
      _selectedTransmission = BlocProvider.of<CarCubit>(context).transmissions[0];
      _selectedFuelType = BlocProvider.of<CarCubit>(context).fuelType[0];
      _selectedColor = BlocProvider.of<AppSettingsCubit>(context).colors[0];
      _selectedFeatures = [];
    });
  }

  void _applyFilters() {
    final filters = {
      'condition': _condition,
      'priceMin': double.tryParse(_priceMinController.text) ?? 0,
      'priceMax': double.tryParse(_priceMaxController.text) ?? 100000,
      'yearMin': int.tryParse(_yearMinController.text) ?? 2000,
      'yearMax': int.tryParse(_yearMaxController.text) ?? DateTime.now().year,
      'mileageMin': int.tryParse(_mileageMinController.text) ?? 0,
      'mileageMax': int.tryParse(_mileageMaxController.text) ?? 200000,
      'make': _selectedMake,
      'model': _selectedModel,
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
          Expanded(child: _buildFilters()),
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
            selectedLang[AppLangAssets.advancedFilter]!,
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(selectedLang[AppLangAssets.condition]!),
          SizedBox(height: 12),
          _buildConditionSelector(),
          
          SizedBox(height: 32),
          _buildSectionTitle(selectedLang[AppLangAssets.priceRange]!),
          SizedBox(height: 12),
          _buildRangeInputs(
            minController: _priceMinController,
            maxController: _priceMaxController,
            prefix: 'EGP ',
            hint: selectedLang[AppLangAssets.price]!,
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle(selectedLang[AppLangAssets.yearRange]!),
          SizedBox(height: 12),
          _buildRangeInputs(
            minController: _yearMinController,
            maxController: _yearMaxController,
            hint: selectedLang[AppLangAssets.year]!,
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle(selectedLang[AppLangAssets.kiloMeterRange]!),
          SizedBox(height: 12),
          _buildRangeInputs(
            minController: _mileageMinController,
            maxController: _mileageMaxController,
            suffix: ' km',
            hint: 'km',
          ),
          
          SizedBox(height: 32),
          _buildSectionTitle(selectedLang[AppLangAssets.make]!),
          SizedBox(height: 8),
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

          SizedBox(height: 24),
          _buildSectionTitle(selectedLang[AppLangAssets.model]!),
          SizedBox(height: 8),
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
          
          SizedBox(height: 24),
          _buildSectionTitle(selectedLang[AppLangAssets.transmission]!),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedTransmission!,
            items: BlocProvider.of<CarCubit>(context).transmissions,
            onChanged: (value) => setState(() => _selectedTransmission = value),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle(selectedLang[AppLangAssets.fuelType]!),
          SizedBox(height: 8),
          _buildDropdown(
            value: _selectedFuelType!,
            items: BlocProvider.of<CarCubit>(context).fuelType,
            onChanged: (value) => setState(() => _selectedFuelType = value),
          ),
          
          SizedBox(height: 24),
          _buildSectionTitle(selectedLang[AppLangAssets.color]!),
          SizedBox(height: 8),
          _buildColorGrid(),
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

  Widget _buildRangeInputs({
    required TextEditingController minController,
    required TextEditingController maxController,
    String? prefix,
    String? suffix,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildNumberInputField(
            controller: minController,
            label: '${selectedLang[AppLangAssets.min]!} $hint',
            prefix: prefix,
            suffix: suffix,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${selectedLang[AppLangAssets.to]!}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: _buildNumberInputField(
            controller: maxController,
            label: '${selectedLang[AppLangAssets.max]!} $hint',
            prefix: prefix,
            suffix: suffix,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInputField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixText: prefix,
          suffixText: suffix,
          prefixStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
          suffixStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
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

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: BlocProvider.of<AppSettingsCubit>(context).colors.map((entry) {
        final isSelected = _selectedColor!.id == entry.id;
        return InkWell(
          onTap: () => setState(() => _selectedColor = entry),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: entry.colorCode,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Color(0xFF3B82F6) : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                    ? Icon(Icons.check, color: Colors.white)
                    : null,
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
                selectedLang[AppLangAssets.reset]!,
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
                selectedLang[AppLangAssets.applyFilters]!,
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