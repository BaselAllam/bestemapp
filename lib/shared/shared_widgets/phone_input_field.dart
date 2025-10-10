import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

// Country data model
class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  Country({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;

  const PhoneInputField({
    Key? key,
    required this.controller,
    this.validator,
    this.labelText,
    this.hintText,
  }) : super(key: key);

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  Country? selectedCountry;
  final TextEditingController _phoneController = TextEditingController();

  final List<Country> countries = [
    Country(name: 'Egypt', code: 'EG', dialCode: '+20', flag: '🇪🇬'),
    // Country(name: 'Saudi Arabia', code: 'SA', dialCode: '+966', flag: '🇸🇦'),
    // Country(name: 'United Arab Emirates', code: 'AE', dialCode: '+971', flag: '🇦🇪'),
  ];

  @override
  void initState() {
    super.initState();
    selectedCountry = countries[0];
    _updateMainController();
    _phoneController.addListener(_updateMainController);
  }

  void _updateMainController() {
    final phoneNumber = _phoneController.text;
    final fullNumber = '${selectedCountry?.dialCode ?? ''}$phoneNumber';
    widget.controller.text = fullNumber;
  }

  Widget _buildCountrySelector() {
    return PopupMenuButton<Country>(
      color: AppColors.whiteColor,
      initialValue: selectedCountry,
      onSelected: (Country country) {
        setState(() {
          selectedCountry = country;
          _updateMainController();
        });
      },
      itemBuilder: (BuildContext context) {
        return countries.map((Country country) {
          return PopupMenuItem<Country>(
            value: country,
            child: Row(
              children: [
                Text(
                  country.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(country.name),
                ),
                Text(
                  country.dialCode,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedCountry?.flag ?? '',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 6),
          Text(
            selectedCountry?.dialCode ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: widget.labelText ?? selectedLang[AppLangAssets.phoneNumber]!,
        hintText: widget.hintText ?? selectedLang[AppLangAssets.enterUrPhoneNumber]!,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildCountrySelector(),
        ),
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return selectedLang[AppLangAssets.plzEnterOnlyPhoneNumber];
            }
            if (value.length < 7) {
              return selectedLang[AppLangAssets.phoneNumberIsTooShort];
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return selectedLang[AppLangAssets.phoneNumberIsTooShort];
            }
            return null;
          },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}