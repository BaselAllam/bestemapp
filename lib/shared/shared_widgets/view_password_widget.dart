import 'package:bestemapp/shared/shared_theme/app_colors.dart';
import 'package:flutter/material.dart';


Widget buildPasswordToggle(bool isSecure, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            isSecure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            key: ValueKey(isSecure),
            color: isSecure ? Colors.grey[400] : AppColors.primaryColor,
            size: 22,
          ),
        ),
      ),
    );
  }