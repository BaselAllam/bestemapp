import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/car_app/logic/car_states.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:bestemapp/shared/shared_widgets/toaster.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReportAdDialog extends StatefulWidget {
  CarAdModel carAdModel;
  ReportAdDialog({required this.carAdModel});

  @override
  State<ReportAdDialog> createState() => _ReportAdDialogState();
}

class _ReportAdDialogState extends State<ReportAdDialog> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  
  final Map<String, Map<String, String>> _reportReasons = {
    "spam": {
      'ar': 'عشوائي أو مضلل',
      'en': 'Spam or misleading'
    },
    "inappropriate": {
      'ar': 'محتوى غير لائق',
      'en': 'Inappropriate Content'
    },
    "fraud": {
      'ar': 'احتيال او نصب',
      'en': 'Fraud or Scam'
    },
    "incorrect": {
      'ar': 'معلومات خاطئه',
      'en': 'Incorrect Information'
    },
    "other": {
      'ar': 'اخرى',
      'en': 'Other'
    },
  };

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedLang[AppLangAssets.reportAd]!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                selectedLang[AppLangAssets.helpUsUnderstand]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                selectedLang[AppLangAssets.reason]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: _reportReasons.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(selectedLang == 'ar' ? entry.value['ar']! : entry.value['en']!),
                    value: entry.key,
                    groupValue: _selectedReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                selectedLang[AppLangAssets.additionalDetails]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _detailsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: selectedLang[AppLangAssets.provideMoreInfo],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<CarCubit, CarStates>(
                  listener: (context, state) {
                    if (state is CreateCarAdReportErrorState) {
                      Toaster.show(
                        context,
                        message: state.errorMsg,
                        position: ToasterPosition.top,
                        type: ToasterType.error
                      );
                    } else if (state is CreateCarAdReportSomeThingWentWrongState) {
                      Toaster.show(
                        context,
                        message: selectedLang[AppLangAssets.someThingWentWrong]!,
                        position: ToasterPosition.top,
                        type: ToasterType.error
                      );
                    } else if (state is CreateCarAdReportSuccessState) {
                      Toaster.show(
                        context,
                        message: selectedLang[AppLangAssets.success]!,
                        position: ToasterPosition.top,
                        type: ToasterType.success
                      );
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) => ElevatedButton(
                    onPressed: _selectedReason == null
                        ? null
                        : state is CreateCarAdReportLoadingState ? () {} : () {
                          BlocProvider.of<CarCubit>(context).reportCarAd(carAd: widget.carAdModel, reason: _selectedReason!, comment: _detailsController.text);
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                  disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(
                      selectedLang[AppLangAssets.submitReport]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}