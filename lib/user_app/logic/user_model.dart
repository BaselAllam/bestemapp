import 'package:bestemapp/app_settings_app/logic/country_model.dart';
import 'package:bestemapp/shared/utils/app_api.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String profilePic;
  String email;
  String phone;
  bool isMale;
  bool isAcceptNotification;
  CountryModel country;

  UserModel({
    required this.id, required this.firstName, required this.lastName, required this.profilePic, required this.email, required this.phone, required this.isMale, required this.isAcceptNotification, required this.country
  });

  factory UserModel.fromJson(Map<String, dynamic> userData) {
    return UserModel(
      id: userData['id'],
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      profilePic: userData['profile_pic'] == null ? '' : '${AppApi.imgIp}${userData['profile_pic']}',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      isAcceptNotification: userData['is_accept_notification'] ?? '',
      isMale: userData['is_male'] ?? '',
      country: CountryModel.fromJson(userData['country'])
    );
  }
}


class SellerModel {
  final String profilePicture;
  final String firstName;
  final String lastName;
  final String phone;

  SellerModel({required this.profilePicture, required this.firstName, required this.lastName, required this.phone});

  factory SellerModel.fromJson(Map<String, dynamic> data) {
    return SellerModel(profilePicture: data['profile_pic'] == null ? '' : '${AppApi.imgIp}${data['profile_pic']}', firstName: data['first_name'], lastName: data['last_name'], phone: data['phone']);
  }
}