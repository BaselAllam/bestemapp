import 'package:bestemapp/shared/utils/app_api.dart';

class LandingBannerModel {
  final String id;
  final String bannerTitle;
  final String bannerTitleAr;
  final String bannerDescription;
  final String bannerDescriptionAr;
  final String createdAt;
  final String bannerImg;

  LandingBannerModel({
    required this.id,
    required this.bannerTitle,
    required this.bannerTitleAr,
    required this.bannerDescription,
    required this.bannerDescriptionAr,
    required this.bannerImg,
    required this.createdAt,
  });

  factory LandingBannerModel.fromJson(Map<String, dynamic> json) {
    return LandingBannerModel(
      id: json['id'] ?? '',
      bannerTitle: json['banner_title'] ?? '',
      bannerTitleAr: json['banner_title_ar'] ?? '',
      bannerDescription: json['banner_description'] ?? '',
      bannerDescriptionAr: json['banner_description_ar'] ?? '',
      bannerImg: '${AppApi.imgIp}${json['banner_img']}',
      createdAt: json['created_at'].toString().substring(0, 11),
    );
  }
}
