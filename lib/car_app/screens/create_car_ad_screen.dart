import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _engineSizeController = TextEditingController();
  final TextEditingController _horsepowerController = TextEditingController();
  final TextEditingController _torqueController = TextEditingController();
  final TextEditingController _accelerationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedCondition;
  String? _selectedBodyType;
  String? _selectedTransmission;
  String? _selectedFuelType;
  String? _selectedDoors;
  String? _selectedSeats;

  List<File> _images = [];
  File? _video;

  final List<String> _conditions = ['New', 'Used', 'Certified'];
  final List<String> _bodyTypes = ['Sedan', 'SUV', 'Coupe', 'Convertible', 'Truck', 'Van'];
  final List<String> _transmissions = ['Automatic', 'Manual', 'CVT'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  final List<String> _doorOptions = ['2', '3', '4', '5'];
  final List<String> _seatOptions = ['2', '4', '5', '7', '8'];

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

  List<StepData> _getSteps() {
    return [
      StepData(
        title: 'Basic Details',
        content: Column(
          children: [
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                hintText: 'e.g., Toyota',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'e.g., Camry',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'e.g., 2023',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: const InputDecoration(labelText: 'Condition'),
              items: _conditions.map((condition) {
                return DropdownMenuItem(value: condition, child: Text(condition));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCondition = value),
              hint: const Text('Select condition'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Mileage (km)',
                hintText: 'e.g., 50000',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBodyType,
              decoration: const InputDecoration(labelText: 'Body Type'),
              items: _bodyTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedBodyType = value),
              hint: const Text('Select body type'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                hintText: 'e.g., Black',
              ),
            ),
          ],
        ),
      ),
      StepData(
        title: 'Upload Images',
        content: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Column(
                children: [
                  Icon(Icons.upload, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _pickImages,
                    child: const Text('Click to upload', style: TextStyle(fontSize: 16)),
                  ),
                  const Text('or drag and drop', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('PNG, JPG, WEBP up to 10MB each', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_images.isNotEmpty) ...[
              Text('${_images.length} image(s) uploaded', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(entry.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      StepData(
        title: 'Upload Video',
        content: Column(
          children: [
            const Text('Upload one video showcasing your car (optional)', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Column(
                children: [
                  Icon(Icons.upload, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _pickVideo,
                    child: const Text('Click to upload', style: TextStyle(fontSize: 16)),
                  ),
                  const Text('or drag and drop', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('MP4, MOV, AVI up to 100MB', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (_video != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.video_library, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_video!.path.split('/').last)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _video = null),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      StepData(
        title: 'Specifications',
        content: Column(
          children: [
            TextField(
              controller: _engineSizeController,
              decoration: const InputDecoration(
                labelText: 'Engine Size',
                hintText: 'e.g., 2.0L',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTransmission,
              decoration: const InputDecoration(labelText: 'Transmission'),
              items: _transmissions.map((trans) {
                return DropdownMenuItem(value: trans, child: Text(trans));
              }).toList(),
              onChanged: (value) => setState(() => _selectedTransmission = value),
              hint: const Text('Select transmission'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFuelType,
              decoration: const InputDecoration(labelText: 'Fuel Type'),
              items: _fuelTypes.map((fuel) {
                return DropdownMenuItem(value: fuel, child: Text(fuel));
              }).toList(),
              onChanged: (value) => setState(() => _selectedFuelType = value),
              hint: const Text('Select fuel type'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDoors,
              decoration: const InputDecoration(labelText: 'Number of Doors'),
              items: _doorOptions.map((doors) {
                return DropdownMenuItem(value: doors, child: Text(doors));
              }).toList(),
              onChanged: (value) => setState(() => _selectedDoors = value),
              hint: const Text('Select doors'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSeats,
              decoration: const InputDecoration(labelText: 'Number of Seats'),
              items: _seatOptions.map((seats) {
                return DropdownMenuItem(value: seats, child: Text(seats));
              }).toList(),
              onChanged: (value) => setState(() => _selectedSeats = value),
              hint: const Text('Select seats'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _horsepowerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Horsepower (optional)',
                hintText: 'e.g., 200 HP',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _torqueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Torque (optional)',
                hintText: 'e.g., 250 Nm',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _accelerationController,
              decoration: const InputDecoration(
                labelText: '0-100 km/h (optional)',
                hintText: 'e.g., 7.5s',
              ),
            ),
          ],
        ),
      ),
      StepData(
        title: 'Description',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 8,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Provide a detailed description of your car, including its condition, maintenance history, any modifications, and why you\'re selling...',
                alignLabelWithHint: true,
              ),
            ),
            Text(
              'Minimum 50 characters (${_descriptionController.text.length}/50)',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      StepData(
        title: 'Pricing',
        content: Column(
          children: [
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'e.g., 25000',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Dubai, UAE',
              ),
            ),
          ],
        ),
      ),
      StepData(
        title: 'Confirmation',
        content: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Review your listing before publishing', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildInfoRow('Brand:', _brandController.text),
              _buildInfoRow('Model:', _modelController.text),
              _buildInfoRow('Year:', _yearController.text),
              _buildInfoRow('Condition:', _selectedCondition ?? 'N/A'),
              _buildInfoRow('Mileage:', '${_mileageController.text} km'),
              _buildInfoRow('Body Type:', _selectedBodyType ?? 'N/A'),
              _buildInfoRow('Color:', _colorController.text),
              const SizedBox(height: 20),
              const Text('Media', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildInfoRow('Images:', '${_images.length} uploaded'),
              _buildInfoRow('Video:', _video != null ? 'Uploaded' : 'None'),
              const SizedBox(height: 20),
              const Text('Specifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildInfoRow('Engine:', _engineSizeController.text),
              _buildInfoRow('Transmission:', _selectedTransmission ?? 'N/A'),
              _buildInfoRow('Fuel Type:', _selectedFuelType ?? 'N/A'),
              _buildInfoRow('Doors:', _selectedDoors ?? 'N/A'),
              _buildInfoRow('Seats:', _selectedSeats ?? 'N/A'),
              const SizedBox(height: 20),
              const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(_descriptionController.text.isEmpty ? 'No description' : _descriptionController.text),
              const SizedBox(height: 20),
              const Text('Pricing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('\$${_priceController.text}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              _buildInfoRow('Location:', _locationController.text),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value.isEmpty ? 'N/A' : value)),
        ],
      ),
    );
  }

  Widget _buildHorizontalStepper() {
    final steps = [
      'Basic Details',
      'Images',
      'Video',
      'Specs',
      'Description',
      'Pricing',
      'Review'
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
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Line between steps
            final stepIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: stepIndex < _currentStep ? AppColors.primaryColor : Colors.grey[300],
              ),
            );
          } else {
            // Step circle
            final stepIndex = index ~/ 2;
            final isActive = stepIndex == _currentStep;
            final isCompleted = stepIndex < _currentStep;

            return Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.primaryColor
                        : isActive
                            ? AppColors.primaryColor
                            : Colors.grey[300],
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    steps[stepIndex],
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? AppColors.primaryColor : Colors.grey[600],
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
      backgroundColor: AppColors.ofWhiteColor,
      appBar: AppBar(
        title: const Text('Create Car Ad'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHorizontalStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[_currentStep].title as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  steps[_currentStep].content,
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _currentStep--);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentStep < steps.length - 1) {
                              setState(() => _currentStep++);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Car ad created successfully!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(_currentStep == steps.length - 1 ? 'Publish' : 'Next'),
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
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _colorController.dispose();
    _engineSizeController.dispose();
    _horsepowerController.dispose();
    _torqueController.dispose();
    _accelerationController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}