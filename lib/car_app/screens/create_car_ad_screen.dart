import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
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

class CarAdCreationPage extends StatefulWidget {
  const CarAdCreationPage({Key? key}) : super(key: key);

  @override
  State<CarAdCreationPage> createState() => _CarAdCreationPageState();
}

class _CarAdCreationPageState extends State<CarAdCreationPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form data
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _horsepowerController = TextEditingController();
  final TextEditingController _torqueController = TextEditingController();
  final TextEditingController _accelerationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedBrand;
  String? _selectedYear;
  String? _selectedCondition;
  String? _selectedBodyType;
  String? _selectedTransmission;
  String? _selectedFuelType;
  String? _selectedDoors;
  String? _selectedSeats;
  String? _selectedEngineSize;
  String? _selectedCity;
  String? _selectedArea;

  List<File> _images = [];
  File? _video;

  // Dropdown options
  final List<String> _brands = ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Audi', 'Ford', 'Chevrolet', 'Nissan', 'Hyundai', 'Kia'];
  final List<String> _years = List.generate(50, (index) => (DateTime.now().year - index).toString());
  final List<String> _conditions = ['New', 'Used', 'Certified'];
  final List<String> _bodyTypes = ['Sedan', 'SUV', 'Coupe', 'Convertible', 'Truck', 'Van', 'Hatchback', 'Wagon'];
  final List<String> _transmissions = ['Automatic', 'Manual', 'CVT'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Plug-in Hybrid'];
  final List<String> _doorOptions = ['2', '3', '4', '5'];
  final List<String> _seatOptions = ['2', '4', '5', '7', '8'];
  final List<String> _engineSizes = ['1.0L', '1.2L', '1.4L', '1.5L', '1.6L', '1.8L', '2.0L', '2.5L', '3.0L', '3.5L', '4.0L', '5.0L'];
  
  final Map<String, List<String>> _citiesWithAreas = {
    'Dubai': ['Downtown Dubai', 'Dubai Marina', 'Jumeirah', 'Business Bay', 'Deira', 'Bur Dubai', 'Al Barsha'],
    'Abu Dhabi': ['Al Reem Island', 'Yas Island', 'Saadiyat Island', 'Al Raha Beach', 'Khalifa City', 'Al Reef'],
    'Sharjah': ['Al Majaz', 'Al Nahda', 'Al Khan', 'Al Qasimia', 'Muwailih', 'Al Taawun'],
    'Ajman': ['Al Nuaimiya', 'Al Rashidiya', 'Al Rawda', 'Al Jurf', 'Al Bustan'],
    'Ras Al Khaimah': ['Al Nakheel', 'Al Hamra', 'Mina Al Arab', 'Al Qusaidat', 'Dafan Al Nakheel'],
    'Fujairah': ['Al Faseel', 'Al Gurfa', 'Sakamkam', 'Dibba Al Fujairah'],
    'Umm Al Quwain': ['Old Town', 'Al Raas', 'Al Salamah', 'Falaj Al Mualla'],
  };

  List<String> _areas = [];

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty && pickedFiles.length <= 20) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    } else if (pickedFiles.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 20 images allowed')),
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
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video size must be less than 100MB')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
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
      StepData(
        title: selectedLang[AppLangAssets.basicDetails]!,
        content: Column(
          children: [
            customDropdown(
              title: '${selectedLang[AppLangAssets.brand]} *',
              hint: selectedLang[AppLangAssets.selectBrand]!,
              value: _selectedBrand,
              items: _brands,
              onChanged: (value) => setState(() => _selectedBrand = value),
              fillColor: Colors.grey.shade50,
            ),
            authField(
              title: '${selectedLang[AppLangAssets.model]} *',
              inputTitle: 'e.g., Camry',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.next,
              keyBoardType: TextInputType.text,
              formaters: [],
              controller: _modelController,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.year]} *',
              hint: selectedLang[AppLangAssets.selectYear]!,
              value: _selectedYear,
              items: _years,
              onChanged: (value) => setState(() => _selectedYear = value),
              fillColor: Colors.grey.shade50,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.condition]} *',
              hint: selectedLang[AppLangAssets.selectCondition]!,
              value: _selectedCondition,
              items: _conditions,
              onChanged: (value) => setState(() => _selectedCondition = value),
              fillColor: Colors.grey.shade50,
            ),
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
            customDropdown(
              title: '${selectedLang[AppLangAssets.bodyType]} *',
              hint: selectedLang[AppLangAssets.selectBodyType]!,
              value: _selectedBodyType,
              items: _bodyTypes,
              onChanged: (value) => setState(() => _selectedBodyType = value),
              fillColor: Colors.grey.shade50,
            ),
            authField(
              title: '${selectedLang[AppLangAssets.color]} *',
              inputTitle: 'e.g., Black',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.done,
              keyBoardType: TextInputType.text,
              formaters: [],
              controller: _colorController,
            ),
          ],
        ),
      ),
      StepData(
        title: selectedLang[AppLangAssets.uploadImg]!,
        content: Column(
          children: [
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
                  const SizedBox(height: 8),
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
                      '${_images.length} ${selectedLang[AppLangAssets.imgsUploadedSuccess]}',
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
          ],
        ),
      ),
      StepData(
        title: selectedLang[AppLangAssets.uploadVideo]!,
        content: Column(
          children: [
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
      StepData(
        title: selectedLang[AppLangAssets.specs]!,
        content: Column(
          children: [
            customDropdown(
              title: '${selectedLang[AppLangAssets.engine]} *',
              hint: selectedLang[AppLangAssets.selectEngineSize]!,
              value: _selectedEngineSize,
              items: _engineSizes,
              onChanged: (value) => setState(() => _selectedEngineSize = value),
              fillColor: Colors.grey.shade50,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.transmission]} *',
              hint: selectedLang[AppLangAssets.selectTransimission]!,
              value: _selectedTransmission,
              items: _transmissions,
              onChanged: (value) => setState(() => _selectedTransmission = value),
              fillColor: Colors.grey.shade50,
            ),
            customDropdown(
              title: '${selectedLang[AppLangAssets.fuelType]} *',
              hint: selectedLang[AppLangAssets.selectFuelType]!,
              value: _selectedFuelType,
              items: _fuelTypes,
              onChanged: (value) => setState(() => _selectedFuelType = value),
              fillColor: Colors.grey.shade50,
            ),
            authField(
              title: '0-100 km/h',
              inputTitle: 'e.g., 7.5s',
              inputStyle: const TextStyle(fontSize: 16),
              fillColor: Colors.grey.shade50,
              textInputAction: TextInputAction.done,
              keyBoardType: const TextInputType.numberWithOptions(decimal: true),
              formaters: [FilteringTextInputFormatter.digitsOnly],
              controller: _accelerationController,
            ),
          ],
        ),
      ),
      StepData(
        title: selectedLang[AppLangAssets.description]!,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedLang[AppLangAssets.adDescriptionToAttract]!,
                      style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
          ],
        ),
      ),
      StepData(
        title: selectedLang[AppLangAssets.pricingAndLocation]!,
        content: Column(
          children: [
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
            const SizedBox(height: 8),
            customDropdown(
              title: '${selectedLang[AppLangAssets.city]} *',
              hint: selectedLang[AppLangAssets.selectCity]!,
              value: _selectedCity,
              items: _citiesWithAreas.keys.toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                  _selectedArea = null;
                  _areas = value != null ? _citiesWithAreas[value]! : [];
                });
              },
              fillColor: Colors.grey.shade50,
            ),
            if (_selectedCity != null)
              customDropdown(
                title: '${selectedLang[AppLangAssets.area]} *',
                hint: selectedLang[AppLangAssets.selectArea]!,
                value: _selectedArea,
                items: _areas,
                onChanged: (value) => setState(() => _selectedArea = value),
                fillColor: Colors.grey.shade50,
              ),
          ],
        ),
      ),
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
              _buildInfoRow('${selectedLang[AppLangAssets.brand]!}:', _selectedBrand ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.model]!}:', _modelController.text),
              _buildInfoRow('${selectedLang[AppLangAssets.year]!}:', _selectedYear ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.condition]!}:', _selectedCondition ?? 'N/A'),
              _buildInfoRow('Mileage:', _mileageController.text.isNotEmpty ? '${_mileageController.text} km' : 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.bodyType]!}:', _selectedBodyType ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.color]!}:', _colorController.text),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.media]!, Icons.photo_library_outlined),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.images]!}:', '${_images.length} uploaded'),
              _buildInfoRow('${selectedLang[AppLangAssets.video]!}:', _video != null ? 'Uploaded' : 'None'),
              const SizedBox(height: 24),
              _buildSectionHeader(selectedLang[AppLangAssets.specs]!, Icons.settings_outlined),
              const SizedBox(height: 12),
              _buildInfoRow('${selectedLang[AppLangAssets.engine]!}:', _selectedEngineSize ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.transmission]!}:', _selectedTransmission ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.fuelType]!}:', _selectedFuelType ?? 'N/A'),
              _buildInfoRow('Doors:', _selectedDoors ?? 'N/A'),
              _buildInfoRow('Seats:', _selectedSeats ?? 'N/A'),
              if (_horsepowerController.text.isNotEmpty)
                _buildInfoRow('Horsepower:', '${_horsepowerController.text} HP'),
              if (_torqueController.text.isNotEmpty)
                _buildInfoRow('Torque:', '${_torqueController.text} Nm'),
              if (_accelerationController.text.isNotEmpty)
                _buildInfoRow('0-100 km/h:', '${_accelerationController.text}s'),
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
                      _priceController.text.isNotEmpty ? '${_priceController.text} AED' : 'N/A',
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
              _buildInfoRow('${selectedLang[AppLangAssets.city]}:', _selectedCity ?? 'N/A'),
              _buildInfoRow('${selectedLang[AppLangAssets.area]}:', _selectedArea ?? 'N/A'),
            ],
          ),
        ),
      ),
    ];
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
      selectedLang[AppLangAssets.images],
      selectedLang[AppLangAssets.video],
      selectedLang[AppLangAssets.specs],
      selectedLang[AppLangAssets.description],
      selectedLang[AppLangAssets.pricing],
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(selectedLang[AppLangAssets.createCarAd]!, style: TextStyle(fontWeight: FontWeight.w600)),
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
                          listener: (context, state) {},
                          builder: (context, state) => ElevatedButton(
                            onPressed: () {
                              if (_currentStep < steps.length - 1) {
                                setState(() => _currentStep++);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Car ad created successfully!'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
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
                                  _currentStep == steps.length - 1 ? selectedLang[AppLangAssets.publishAd]! : selectedLang[AppLangAssets.continueStep]!,
                                  style: TextStyle(fontSize: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 8),
                                Icon(_currentStep == steps.length - 1 ? Icons.publish : Icons.arrow_forward, color: AppColors.whiteColor,),
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
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _horsepowerController.dispose();
    _torqueController.dispose();
    _accelerationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}