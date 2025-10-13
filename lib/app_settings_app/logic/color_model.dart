import 'package:flutter/material.dart';

class ColorModel {
  final String id;
  final Color colorCode;
  final String colorName;

  ColorModel({
    required this.id,
    required this.colorCode,
    required this.colorName,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'] ?? '',
      colorCode: Color(int.parse('0xff${json['color_code']}')),
      colorName: json['color_name'] ?? '',
    );
  }
}
