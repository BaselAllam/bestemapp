import 'package:bestemapp/car_app/logic/car_model.dart';
import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


class ReportAdDialog extends StatefulWidget {
  CarAdModel carAdModel;
  ReportAdDialog({required this.carAdModel});

  @override
  State<ReportAdDialog> createState() => _ReportAdDialogState();
}

class _ReportAdDialogState extends State<ReportAdDialog> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  
  final List<String> _reportReasons = [
    'Spam or Misleading',
    'Inappropriate Content',
    'Fraud or Scam',
    'Duplicate Listing',
    'Incorrect Information',
    'Other',
  ];

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
                  const Text(
                    'Report Ad',
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
                'Help us understand the problem',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Reason',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ..._reportReasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF3B82F6),
                );
              }).toList(),
              const SizedBox(height: 16),
              const Text(
                'Additional Details (Optional)',
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
                  hintText: 'Provide more information about your report...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF3B82F6),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedReason == null
                      ? null
                      : () {
                          // Handle report submission
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Report submitted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: const Text(
                    'Submit Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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