import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/color_model.dart';
import 'package:bestemapp/app_settings_app/logic/country_model.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StepData {
  final String title;
  final Widget content;

  StepData({required this.title, required this.content});
}

class CarAdEditScreen extends StatefulWidget {
  final CarAdModel carAd;
  
  const CarAdEditScreen({Key? key, required this.carAd}) : super(key: key);

  @override
  State<CarAdEditScreen> createState() => _CarAdEditScreenState();
}

class _CarAdEditScreenState extends State<CarAdEditScreen> {
  int _currentStep = 0;
  var _formKey = GlobalKey<FormState>();
  ImagePicker _picker = ImagePicker();
  
  late TextEditingController _adTitleController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;
  late TextEditingController _maxDistanceController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _engineSizeController;
  late TextEditingController _phoneController;
  Map<String, bool> _boolValues = {};
  Map<String, TextEditingController> _controllers = {};

  CarMakeModel? _selectedBrand;
  CarMakeModelModel? _selectedModel;
  ColorModel? selectedColor;
  String? _selectedCondition;
  CarShapeModel? _selectedBodyType;
  String? _selectedTransmission;
  String? _selectedFuelType;
  CityModel? _selectedCity;
  AreaModel? _selectedArea;
  late bool isNegotiable;

  List<File> _images = [];
  List<CarAdImg> _existingImages = [];
  File? _video;
  String? _existingVideo;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingData();
  }

  void _initializeControllers() {
    _adTitleController = TextEditingController(text: widget.carAd.adTitle);
    _yearController = TextEditingController(text: widget.carAd.carYear.toString());
    _mileageController = TextEditingController(text: widget.carAd.distanceRange.toString());
    _maxDistanceController = TextEditingController(text: widget.carAd.distanceRange.toString());
    _descriptionController = TextEditingController(text: widget.carAd.adDescription);
    _priceController = TextEditingController(text: widget.carAd.price);
    _engineSizeController = TextEditingController(text: widget.carAd.engineCapacity.toString());
    _phoneController = TextEditingController(text: widget.carAd.contactPhone.isEmpty ? BlocProvider.of<UserCubit>(context).userModel!.phone : widget.carAd.contactPhone.toString());
    
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  void _loadExistingData() {
    isNegotiable = widget.carAd.isNegotiable;
    _selectedCondition = widget.carAd.carCondition;
    _selectedTransmission = widget.carAd.transmissionType;
    _selectedFuelType = widget.carAd.fuelType;
    _selectedModel = widget.carAd.carModel;
    selectedColor = widget.carAd.carColor;
    _selectedBodyType = widget.carAd.carShape;
    _selectedArea = widget.carAd.adArea;
    final carCubit = BlocProvider.of<CarCubit>(context);
    for (var make in carCubit.carMakes) {
      if (make.models.any((model) => model.id == _selectedModel!.id)) {
        _selectedBrand = make;
        break;
      }
    }
    final appSettingsCubit = BlocProvider.of<AppSettingsCubit>(context);
    for (var city in appSettingsCubit.countries[0].cities) {
      if (city.areas.any((area) => area.id == _selectedArea!.id)) {
        _selectedCity = city;
        break;
      }
    }
    _existingImages = widget.carAd.adImgs;
    if (widget.carAd.adVideo.isNotEmpty) {
      _existingVideo = widget.carAd.adVideo;
    }
    for (var specValue in widget.carAd.specs) {
      String specId = specValue['spec']['id'];
      if (specValue.containsKey('value_boolean')) {
        _boolValues[specId] = specValue['value_boolean'] ?? false;
      } else if (specValue.containsKey('value_number')) {
        _controllers[specId] = TextEditingController(text: specValue['value_number']?.toString() ?? '');
      } else if (specValue.containsKey('value_text')) {
        _controllers[specId] = TextEditingController(text: specValue['value_text'] ?? '');
      }
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty && (pickedFiles.length + _existingImages.length) <= 20) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    } else if ((pickedFiles.length + _existingImages.length) > 20) {
      Toaster.show(
        context,
        message: selectedLang[AppLangAssets.maximumImgs]!,
        position: ToasterPosition.top,
        type: ToasterType.warning
      );
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      if (fileSize <= 100 * 1024 * 1024) {
        setState(() {
          _video = file;
          _existingVideo = null;
        });
      } else {
        Toaster.show(
          context,
          message: selectedLang[AppLangAssets.videoSize]!,
          position: ToasterPosition.top,
          type: ToasterType.warning
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  Widget customDropdown({
    required String title,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    Color fillColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.whiteColor,
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: fillColor,
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
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  List<StepData> _getSteps() {
    return [
      // Step 1: Basic Details
      StepData(
        title: selectedLang[AppLangAssets.basicDetails]!,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedLang[AppLangAssets.adtitle]} *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _adTitleController,
                    maxLength: 75,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: selectedLang[AppLangAssets.adtitle],
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.all(16),
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${selectedLang[AppLangAssets.description]} *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 8,
                    maxLength: 1000,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: selectedLang[AppLangAssets.adCarDescription],
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.all(16),
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _descriptionController.text.length >= 50 ? Icons.check_circle : Icons.info_outline,
                        size: 16,
                        color: _descriptionController.text.length >= 50 ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${selectedLang[AppLangAssets.minimumCharacter]} (${_descriptionController.text.length}/50)',
                        style: TextStyle(
                          color: _descriptionController.text.length >= 50 ? Colors.green : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            authField(
              title: '${selectedLang[AppLangAssets.pricing]} *',
              inputTitle: 'e.g., 25000',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.number,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _priceController,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('EGP', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedLang[AppLangAssets.isNegotiable]!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: isNegotiable,
                    activeColor: AppColors.primaryColor,
                    focusColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.whiteColor,
                    inactiveTrackColor: AppColors.greyColor,
                    onChanged: (value) {
                      setState(() {
                        isNegotiable = !isNegotiable;
                      });
                    }
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _descriptionController.text.length >= 50 ? Icons.check_circle : Icons.info_outline,
                  size: 16,
                  color: _descriptionController.text.length >= 50 ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${selectedLang[AppLangAssets.realPricing]}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedLang[AppLangAssets.city]} *',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CityModel>(
                    dropdownColor: AppColors.whiteColor,
                    value: _selectedCity,
                    decoration: InputDecoration(
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
                      setState(() {
                        _selectedCity = value;
                        _selectedArea = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_selectedCity != null)
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedLang[AppLangAssets.area]} *',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<AreaModel>(
                      dropdownColor: AppColors.whiteColor,
                      value: _selectedArea != null && _selectedCity!.areas.any((a) => a.id == _selectedArea!.id)
              ? _selectedCity!.areas.firstWhere((a) => a.id == _selectedArea!.id)
              : null,
                      decoration: InputDecoration(
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
                      items: _selectedCity!.areas.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item.areaName));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedArea = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      
      // Step 2: Car Data
      StepData(
        title: selectedLang[AppLangAssets.carData]!,
        content: Column(
          children: [
            customDropdown(
              title: '${selectedLang[AppLangAssets.condition]} *',
              hint: selectedLang[AppLangAssets.selectCondition]!,
              value: _selectedCondition,
              items: BlocProvider.of<CarCubit>(context).conditions,
              onChanged: (value) => setState(() => _selectedCondition = value),
              fillColor: Colors.grey.shade50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedLang[AppLangAssets.brand]} *',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CarMakeModel>(
                    dropdownColor: AppColors.whiteColor,
                    value: _selectedBrand,
                    decoration: InputDecoration(
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
                      setState(() {
                        _selectedBrand = value;
                        _selectedModel = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_selectedBrand != null)
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedLang[AppLangAssets.model]} *',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CarMakeModelModel>(
                    dropdownColor: AppColors.whiteColor,
                    value: _selectedModel != null && _selectedBrand!.models.any((a) => a.id == _selectedModel!.id)
              ? _selectedBrand!.models.firstWhere((a) => a.id == _selectedModel!.id)
              : null,
                    decoration: InputDecoration(
                      hintText: selectedLang[AppLangAssets.selectModel]!,
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
                    items: _selectedBrand!.models.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item.modelName));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedModel = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            authField(
              title: '${selectedLang[AppLangAssets.year]} *',
              inputTitle: selectedLang[AppLangAssets.selectYear]!,
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.next,
              keyBoardType: TextInputType.number,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _yearController,
            ),
            bodyTypeGridSelector(
              title: '${selectedLang[AppLangAssets.bodyType]} *',
              selectedShape: _selectedBodyType,
              items: BlocProvider.of<CarCubit>(context).carShapes,
              onChanged: (value) => setState(() => _selectedBodyType = value),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${selectedLang[AppLangAssets.color]!} *',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          const SizedBox(height: 12),
            _buildColorGrid(),
            authField(
              title: 'KiloMeters (km) *',
              inputTitle: 'e.g., 50000',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.next,
              keyBoardType: TextInputType.number,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _mileageController,
            ),
            authField(
              title: '${selectedLang[AppLangAssets.engine]} *',
              inputTitle: selectedLang[AppLangAssets.selectEngineSize]!,
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.next,
              keyBoardType: TextInputType.number,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _engineSizeController,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.transmission]} *',
              hint: selectedLang[AppLangAssets.selectTransimission]!,
              value: _selectedTransmission,
              items: BlocProvider.of<CarCubit>(context).transmissions,
              onChanged: (value) => setState(() => _selectedTransmission = value),
              fillColor: Colors.grey.shade50,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.fuelType]} *',
              hint: selectedLang[AppLangAssets.selectFuelType]!,
              value: _selectedFuelType,
              items: BlocProvider.of<CarCubit>(context).fuelType,
              onChanged: (value) => setState(() => _selectedFuelType = value),
              fillColor: Colors.grey.shade50,
            ),
            if (_selectedFuelType == 'electric' || _selectedFuelType == 'hybird')
            authField(
              title: '${selectedLang[AppLangAssets.distanceRange]} *',
              inputTitle: selectedLang[AppLangAssets.selectDistanceRange]!,
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.next,
              keyBoardType: TextInputType.number,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _maxDistanceController,
            ),
          ],
        ),
      ),
      
      // Step 3: Car Specs
      StepData(
        title: selectedLang[AppLangAssets.specs]!,
        content: Column(
          children: [
            for (CarSpecsModel i in BlocProvider.of<CarCubit>(context).carSpecs)
              _buildSpecField(i),
          ],
        ),
      ),
      
      // Step 4: Car Media
      StepData(
        title: selectedLang[AppLangAssets.media]!,
        content: Column(
          children: [
            // Existing Images Section
            if (_existingImages.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Existing Images (${_existingImages.length})',
                        style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _existingImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(_existingImages[index].image),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => _removeExistingImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
            
            // New Images Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.cloud_upload_outlined, size: 60, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.add_photo_alternate, color: AppColors.primaryColor),
                    label: Text(selectedLang[AppLangAssets.chooseImage]!, style: TextStyle(color: AppColors.primaryColor),),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PNG, JPG up to 10MB (20 ${selectedLang[AppLangAssets.maxImgs]})',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_images.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Text(
                      '${_images.length} New ${selectedLang[AppLangAssets.imgsUploadedSuccess]}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_images[index]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 32),
            
            // Video Section
            if (_existingVideo != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Existing Video',
                        style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.video_library, color: AppColors.primaryColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Video',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Video uploaded',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => setState(() => _existingVideo = null),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${selectedLang[AppLangAssets.uploadVideoDescription]} (${selectedLang[AppLangAssets.optional]})',
                      style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.videocam_outlined, size: 60, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: Icon(Icons.video_library, color: AppColors.primaryColor),
                    label: Text(selectedLang[AppLangAssets.chooseVideo]!, style: TextStyle(color: AppColors.primaryColor),),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'MP4 up to 100MB',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (_video != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.video_library, color: AppColors.primaryColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedLang[AppLangAssets.videoUploaded]!,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _video!.path.split('/').last,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => setState(() => _video = null),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      
      // Step 5: Contact Details
      StepData(
        title: selectedLang[AppLangAssets.contactDetails]!,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedLang[AppLangAssets.weWillUseUrPhone]!,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedLang[AppLangAssets.urContactInfo]!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedLang[AppLangAssets.weWillUseUrPhoneVisible]!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            authField(
              title: '${selectedLang[AppLangAssets.phoneNumber]} *',
              inputTitle: 'e.g., 01234567890',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.phone,
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _phoneController,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.phone, color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedLang[AppLangAssets.thisUrRegisterNumber]!,
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shield_outlined, color: AppColors.primaryColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedLang[AppLangAssets.privacyAndSafety]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPrivacyPoint(selectedLang[AppLangAssets.weWillUseUrPhoneVisible]!),
                  _buildPrivacyPoint(selectedLang[AppLangAssets.weRecommendMeeting]!),
                  _buildPrivacyPoint(selectedLang[AppLangAssets.neverShareFinanceInfo]!),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Step 6: Review
      StepData(
        title: selectedLang[AppLangAssets.reviewAndConfirm]!,
        content: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedLang[AppLangAssets.reviewYourListing]!,
                        style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('${selectedLang[AppLangAssets.basicInformation]!}:', Icons.info_outline),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.brand]!}:', _selectedBrand == null ? 'N/A' : _selectedBrand!.makeName),
              _buildInfoRow('${selectedLang[AppLangAssets.model]!}:', _selectedModel == null ? 'N/A' : _selectedModel!.modelName),
              _buildInfoRow('${selectedLang[AppLangAssets.year]!}:', _yearController.text),
              _buildInfoRow('${selectedLang[AppLangAssets.condition]!}:', _selectedCondition ?? 'N/A'),
              _buildInfoRow('KM:', _mileageController.text.isNotEmpty ? '${_mileageController.text} km' : 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.bodyType]!}:', _selectedBodyType == null ? 'N/A' : _selectedBodyType!.shapeName),
              _buildInfoRow('${selectedLang[AppLangAssets.color]!}:', selectedColor == null ? 'N/A' : selectedColor!.colorName),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.media]!, Icons.photo_library_outlined),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.images]!}:', '${_existingImages.length + _images.length} total'),
              _buildInfoRow('${selectedLang[AppLangAssets.video]!}:', (_video != null || _existingVideo != null) ? 'Uploaded' : 'None'),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.specs]!, Icons.settings_outlined),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.engine]!}:', _engineSizeController.text),
              _buildInfoRow('${selectedLang[AppLangAssets.transmission]!}:', _selectedTransmission ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.fuelType]!}:', _selectedFuelType ?? 'N/A'),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.description]!, Icons.description_outlined),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _descriptionController.text.isEmpty ? selectedLang[AppLangAssets.noDescription]! : _descriptionController.text,
                  style: TextStyle(color: Colors.grey.shade800, height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.pricingAndLocation]!, Icons.location_on_outlined),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _priceController.text.isNotEmpty ? '${_priceController.text} EGP' : 'N/A',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.city]}:', _selectedCity == null ? 'N/A' : _selectedCity!.cityName),
              _buildInfoRow('${selectedLang[AppLangAssets.area]}:', _selectedArea == null ? 'N/A' : _selectedArea!.areaName),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildPrivacyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade600, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 64,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${selectedLang[AppLangAssets.success]}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your car ad has been updated successfully!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          selectedLang[AppLangAssets.viewMyAd]!,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          selectedLang[AppLangAssets.done]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecField(CarSpecsModel spec) {
    TextInputType keyboardType;
    List<TextInputFormatter> formatters = [];
    
    switch (spec.specType.toLowerCase()) {
      case 'number':
        keyboardType = const TextInputType.numberWithOptions(decimal: false);
        formatters = [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
        break;
      case 'boolean':
        return _buildBooleanField(spec);
      case 'text':
      default:
        keyboardType = TextInputType.text;
        formatters = [];
    }

    return authField(
      title: spec.spec,
      inputTitle: spec.specType,
      inputStyle: const TextStyle(fontSize: 16),
      fillColor: Colors.grey.shade50,
      textInputAction: TextInputAction.done,
      keyBoardType: keyboardType,
      formaters: formatters,
      controller: _getController(spec),
    );
  }

  Widget _buildBooleanField(CarSpecsModel spec) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            spec.spec,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Switch(
            value: _getBoolValue(spec),
            activeColor: AppColors.primaryColor,
            focusColor: AppColors.primaryColor,
            inactiveThumbColor: AppColors.whiteColor,
            inactiveTrackColor: AppColors.greyColor,
            onChanged: (value) => _setBoolValue(spec, value),
          ),
        ],
      ),
    );
  }

  TextEditingController _getController(CarSpecsModel spec) {
    if (_controllers[spec.id] == null) {
      _controllers[spec.id] = TextEditingController();
    }
    return _controllers[spec.id]!;
  }

  bool _getBoolValue(CarSpecsModel spec) {
    return _boolValues[spec.id] ?? false;
  }

  void _setBoolValue(CarSpecsModel spec, bool value) {
    setState(() {
      _boolValues[spec.id] = value;
    });
  }

  Widget authField({
    required String title,
    required String inputTitle,
    required TextStyle inputStyle,
    required Color fillColor,
    bool enabled = true,
    required TextInputAction textInputAction,
    required TextInputType keyBoardType,
    required List<TextInputFormatter> formaters,
    bool obsecure = false,
    required TextEditingController controller,
    Widget suffix = const SizedBox(),
    bool border = true,
    Function? validatorMethod,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            obscureText: obsecure,
            keyboardType: keyBoardType,
            textInputAction: textInputAction,
            inputFormatters: formaters,
            style: inputStyle,
            validator: (value) => validatorMethod?.call(value) as String?,
            decoration: InputDecoration(
              hintText: inputTitle,
              filled: true,
              fillColor: fillColor,
              suffixIcon: suffix,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: border
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
              enabledBorder: border
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStepper() {
    final steps = [
      selectedLang[AppLangAssets.basicDetails],
      selectedLang[AppLangAssets.carData],
      selectedLang[AppLangAssets.specs],
      selectedLang[AppLangAssets.media],
      selectedLang[AppLangAssets.contactDetails],
      selectedLang[AppLangAssets.review],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            return Container(
              width: 40,
              alignment: Alignment.center,
              child: Container(
                height: 2,
                width: 40,
                color: stepIndex < _currentStep ? AppColors.primaryColor : Colors.grey[300],
              ),
            );
          } else {
            final stepIndex = index ~/ 2;
            final isActive = stepIndex == _currentStep;
            final isCompleted = stepIndex < _currentStep;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isActive ? AppColors.primaryColor : Colors.grey[300],
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 75,
                    child: Text(
                      steps[stepIndex]!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive ? AppColors.primaryColor : Colors.grey[600],
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.whiteColor,
            title: Text(selectedLang[AppLangAssets.exitConfirmation]!),
            content: Text(
              selectedLang[AppLangAssets.areUSureUWantToExit]!,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(selectedLang[AppLangAssets.cancel]!),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  selectedLang[AppLangAssets.exit]!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text('Edit Car Ad', style: TextStyle(fontWeight: FontWeight.w600)),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            _buildHorizontalStepper(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${selectedLang[AppLangAssets.step]} ${_currentStep + 1}/${steps.length}',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      steps[_currentStep].title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    steps[_currentStep].content,
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() => _currentStep--);
                              },
                              icon: Icon(Icons.arrow_back, color: AppColors.greyColor,),
                              label: Text(selectedLang[AppLangAssets.back]!, style: TextStyle(color: AppColors.greyColor)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey.shade300, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: BlocConsumer<CarCubit, CarStates>(
                            listener: (context, state) {
                              if (state is CreateCarAdsErrorState) {
                                Toaster.show(
                                  context,
                                  message: state.errorMsg,
                                  position: ToasterPosition.top,
                                  type: ToasterType.error
                                );
                              } else if (state is CreateCarAdsSomeThingWentWrongState) {
                                Toaster.show(
                                  context,
                                  message: selectedLang[AppLangAssets.someThingWentWrong]!,
                                  position: ToasterPosition.top,
                                  type: ToasterType.error
                                );
                              } else if (state is CreateCarAdsSuccessState) {
                                _showSuccessDialog(context);
                              }
                            },
                            builder: (context, state) => ElevatedButton(
                              onPressed: state is CreateCarAdsLoadingState ? () {} : () {
                                if (_currentStep < steps.length - 1) {
                                  setState(() => _currentStep++);
                                } else {
                                  if (_adTitleController.text.isEmpty || _descriptionController.text.isEmpty || _selectedModel == null || selectedColor == null ||
                                  _selectedBodyType == null || _selectedArea == null || _selectedCondition == null || _selectedFuelType == null || _selectedTransmission == null ||
                                  _engineSizeController.text.isEmpty || _yearController.text.isEmpty || _mileageController.text.isEmpty || _priceController.text.isEmpty || 
                                  (_images.isEmpty && _existingImages.isEmpty)) {
                                    Toaster.show(
                                      context,
                                      message: selectedLang[AppLangAssets.fieldsRequired]!,
                                      type: ToasterType.error,
                                      position: ToasterPosition.top
                                    );
                                  } else {
                                    BlocProvider.of<CarCubit>(context).updateCarAd(
                                      carAd: widget.carAd,
                                      adTitle: _adTitleController.text, 
                                      adDescription: _descriptionController.text,
                                      carModel: _selectedModel!.id,
                                      carColor: selectedColor!.id,
                                      carShape: _selectedBodyType!.id,
                                      adArea: _selectedArea!.id,
                                      carCondition: _selectedCondition!,
                                      fuelType: _selectedFuelType!,
                                      transmissionType: _selectedTransmission!,
                                      engineCapacity: int.parse(_engineSizeController.text),
                                      carYear: int.parse(_yearController.text),
                                      kiloMeters: int.parse(_mileageController.text),
                                      price: _priceController.text,
                                      isNegotioable: isNegotiable,
                                      video: _video ?? null,
                                      imgs: _images,
                                      distanceRange: _selectedFuelType == 'electric' || _selectedFuelType == 'hybird' ? int.parse(_maxDistanceController.text) : 0,
                                      specsValues: _prepareSpecsValues(),
                                      deleteImgsIds: [],
                                      deleteSpecsIds: [],
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: AppColors.primaryColor,
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentStep == steps.length - 1 ? 'Update Ad' : state is CreateCarAdsLoadingState ?
                                    selectedLang[AppLangAssets.loading]! : selectedLang[AppLangAssets.continueStep]!,
                                    style: TextStyle(fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(_currentStep == steps.length - 1 ? Icons.check : Icons.arrow_forward, color: AppColors.whiteColor,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareSpecsValues() {
    List<Map<String, dynamic>> values = [];
    for (var i in _boolValues.keys) {
      values.add({'spec': i, 'value_boolean': _boolValues[i]});
    }
    for (var i in _controllers.keys) {
      Map<String, dynamic> data = {
        'spec': i,
      };
      for (var x in BlocProvider.of<CarCubit>(context).carSpecs) {
        if (i == x.id) {
          if (x.specType == 'number') {
            data['value_number'] = _controllers[i]!.text;
          } else {
            data['value_text'] = _controllers[i]!.text;
          }
          break;
        }
      }
      values.add(data);
    }
    return values;
  }

  Widget bodyTypeGridSelector({
    required String title,
    required CarShapeModel? selectedShape,
    required List<CarShapeModel> items,
    required Function(CarShapeModel?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedShape!.id == item.id;

              return GestureDetector(
                onTap: () => onChanged(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryColor.withOpacity(0.1) 
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primaryColor 
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(item.shapeIcon, height: 50, width: 50,),
                      const SizedBox(height: 8),
                      Text(
                        item.shapeName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected 
                              ? AppColors.primaryColor 
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: BlocProvider.of<AppSettingsCubit>(context).colors.map((entry) {
        final isSelected = selectedColor == null ? false : selectedColor!.id == entry.id;
        return InkWell(
          onTap: () => setState(() => selectedColor = entry),
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

  @override
  void dispose() {
    _mileageController.dispose();
    _descriptionController.dispose();
    _adTitleController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    _yearController.dispose();
    _engineSizeController.dispose();
    _maxDistanceController.dispose();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}