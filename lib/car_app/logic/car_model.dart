import 'package:bestemapp/app_settings_app/logic/color_model.dart';
import 'package:bestemapp/app_settings_app/logic/country_model.dart';
import 'package:bestemapp/user_app/logic/user_model.dart';
import 'package:flutter/material.dart';

class CarAdWishlistModel {
  final String id;
  CarAdModel carAdModel;

  CarAdWishlistModel({required this.id, required this.carAdModel});
}

class CarAdImg {
  final String id;
  final String image;

  CarAdImg({required this.id, required this.image});

  factory CarAdImg.fromJson(Map<String, dynamic> data) {
    return CarAdImg(id: data['id'], image: '${data['image']}');
  }
}

class CarAdModel {
  final String id;
  bool isFav;
  String adStatus;
  String submittedAt;
  String carCondition;
  String adTitle;
  String adDescription;
  CarMakeModelModel carModel;
  int carYear;
  ColorModel carColor;
  String price;
  bool isNegotiable;
  AreaModel adArea;
  String fuelType;
  String transmissionType;
  int engineCapacity;
  int kilometers;
  int distanceRange;
  CarShapeModel carShape;
  String adVideo;
  List<CarAdImg> adImgs;
  List<Map<String, dynamic>> specs;
  int viewsCount;
  SellerModel seller;
  String contactPhone;
  Map<String, dynamic> carMake;

  CarAdModel({required this.id, required this.isFav, required this.adStatus, required this.submittedAt, required this.carCondition, required this.adTitle, required this.adDescription,
  required this.carModel, required this.carYear, required this.carColor, required this.price, required this.isNegotiable, required this.adArea, required this.fuelType, required this.transmissionType,
  required this.engineCapacity, required this.kilometers, required this.distanceRange, required this.carShape, required this.adVideo, required this.adImgs, required this.specs, required this.viewsCount,
  required this.seller, required this.contactPhone, required this.carMake,
  });

  factory CarAdModel.fromJson(Map<String, dynamic> json) {
    return CarAdModel(
      id: json['id'] ?? '',
      isFav: json['isFav'] ?? false,
      adStatus: json['ad_status'] ?? '',
      submittedAt: json['submitted_at'] ?? '',
      carCondition: json['car_condition'] ?? '',
      adTitle: json['ad_title'] ?? '',
      adDescription: json['ad_description'] ?? '',
      carModel: json['car_model'] != null ? CarMakeModelModel.fromJson(json['car_model']) : CarMakeModelModel(id: '', modelName: ''),
      carYear: json['car_year'] ?? 0,
      carColor: json['car_color'] != null ? ColorModel.fromJson(json['car_color']) : ColorModel(id: '', colorCode: Colors.black, colorName: ''),
      price: json['price'].toString(),
      isNegotiable: json['is_negotiable'] ?? false,
      adArea: json['ad_area'] != null ? AreaModel.fromJson(json['ad_area']) : AreaModel(id: '', areaName: '', areaNameAr: ''),
      fuelType: json['fuel_type'] ?? '',
      transmissionType: json['transmission_type'] ?? '',
      engineCapacity: json['engine_capacity'] ?? 0,
      kilometers: json['kilometers'] ?? 0,
      distanceRange: json['distance_range'] ?? 0,
      carShape: json['car_shape'] != null ? CarShapeModel.fromJson(json['car_shape']) : CarShapeModel(id: '', shapeName: '', shapeIcon: ''),
      seller: json['user'] != null ? SellerModel.fromJson(json['user']) : SellerModel(profilePicture: '', firstName: '', lastName: '', phone: ''),
      adVideo: json['ad_video'] ?? '',
      adImgs: (json['imgs'] as List?)?.map((img) => CarAdImg.fromJson(img)).toList() ?? [],
      specs: (json['specs_value'] as List?)?.map((spec) => Map<String, dynamic>.from(spec)).toList() ?? [],
      viewsCount: json['views_count'],
      contactPhone: json['contact_phone'] ?? '',
      carMake: json['car_make'] ?? {}
    );
  }
}

class CarSpecsModel {
  final String id;
  final String spec;
  final String specType;

  CarSpecsModel({
    required this.id,
    required this.spec,
    required this.specType,
  });

  factory CarSpecsModel.fromJson(Map<String, dynamic> json) {
    return CarSpecsModel(
      id: json['id'] ?? '',
      spec: json['spec'] ?? '',
      specType: json['spec_type'] ?? '',
    );
  }
}

class CarShapeModel {
  final String id;
  final String shapeName;
  final String shapeIcon;

  CarShapeModel({
    required this.id,
    required this.shapeName,
    required this.shapeIcon,
  });

  factory CarShapeModel.fromJson(Map<String, dynamic> json) {
    return CarShapeModel(
      id: json['id'] ?? '',
      shapeName: json['shape_name'] ?? '',
      shapeIcon: '${json['shape_icon']}',
    );
  }
}

class CarMakeModel {
  final String id;
  final String makeName;
  final String makeLogo;
  final List<CarMakeModelModel> models;
  final bool isPopular;

  CarMakeModel({
    required this.id,
    required this.makeName,
    required this.makeLogo,
    required this.models,
    required this.isPopular
  });

  factory CarMakeModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModel(
      id: json['id'] ?? '',
      makeName: json['make_name'] ?? '',
      makeLogo: '${json['make_logo']}',
      models: (json['models'] as List<dynamic>?)
              ?.map((m) => CarMakeModelModel.fromJson(m))
              .toList() ??
          [],
      isPopular: json['is_popular']
    );
  }
}

class CarMakeModelModel {
  final String id;
  final String modelName;

  CarMakeModelModel({
    required this.id,
    required this.modelName,
  });

  factory CarMakeModelModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModelModel(
      id: json['id'] ?? '',
      modelName: json['model_name'] ?? '',
    );
  }
}
