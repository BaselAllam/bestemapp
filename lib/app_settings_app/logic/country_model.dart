class CountryModel {
  final String id;
  final String countryName;
  final String countryNameAr;
  final String countryFlag;
  List<CityModel> cities;

  CountryModel({
    required this.id,
    required this.countryName,
    required this.countryNameAr,
    required this.countryFlag,
    required this.cities,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? '',
      countryName: json['country_name'] ?? '',
      countryNameAr: json['country_name_ar'] ?? '',
      countryFlag: json['country_flag_url'] ?? '',
      cities: (json['cities'] as List<dynamic>?)
              ?.map((city) => CityModel.fromJson(city))
              .toList() ??
          [],
    );
  }
}

class CityModel {
  final String id;
  final String cityName;
  final String cityNameAr;
  List<AreaModel> areas;

  CityModel({
    required this.id,
    required this.cityName,
    required this.cityNameAr,
    required this.areas,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? '',
      cityName: json['city_name'] ?? '',
      cityNameAr: json['city_name_ar'] ?? '',
      areas: (json['areas'] as List<dynamic>?)
              ?.map((area) => AreaModel.fromJson(area))
              .toList() ??
          [],
    );
  }
}

class AreaModel {
  final String id;
  final String areaName;
  final String areaNameAr;

  AreaModel({
    required this.id,
    required this.areaName,
    required this.areaNameAr,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? '',
      areaName: json['area_name'] ?? '',
      areaNameAr: json['area_name_ar'] ?? '',
    );
  }
}
