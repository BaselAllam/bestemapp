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
  String country;

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
      country: userData['country'] ?? ''
    );
  }
}