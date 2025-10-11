import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/shared/utils/app_lang_assets.dart';
import 'package:flutter/material.dart';

class NoResultFoundWidget extends StatefulWidget {
  const NoResultFoundWidget({super.key});

  @override
  State<NoResultFoundWidget> createState() => _NoResultFoundWidgetState();
}

class _NoResultFoundWidgetState extends State<NoResultFoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            selectedLang[AppLangAssets.noResultFound]!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}