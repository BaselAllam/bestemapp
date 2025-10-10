import 'dart:io';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:bestemapp/user_app/logic/user_model.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:restart_app/restart_app.dart';

class UserCubit extends Cubit<UserStates> {

  UserCubit() : super(InitialUserState());

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> login(String phone, String password) async {
    emit(LoginLoadingState());
    try {
      http.Response response = await http.post(Uri.parse('${AppApi.ipAddress}/users/login/'), headers: AppApi.headerData, body: json.encode({'phone': phone, 'password': password}));
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        await saveStringToLocal(AppApi.userToken, data['data']['access']);
        await saveStringToLocal(AppApi.userRefreshToken, data['data']['refresh_token']);
        if (!data['data']['is_phoneVerifued']) {
          emit(LoginOTPState());
          return;
        }
        emit(LoginSuccessState());
        return;
      } else {
        emit(LoginErrorState(data['data']));
        return;
      }
    } catch (e) {
      emit(LoginSomeThingWentWrongState());
    }
  }

  void register({required String email, required String password, required String confirmPassword, required String firstName, required String lastName, required String phone, required String country, required bool isMale}) async {
    emit(RegisterLoadingState());
    try {
      Map<String, dynamic> toSendData = {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'country': country,
        'is_male': isMale,
      };
      http.Response response = await http.post(Uri.parse('${AppApi.ipAddress}/users/register/'), headers: AppApi.headerData, body: json.encode(toSendData));
      var data = json.decode(response.body);
      if (response.statusCode == 201) {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterErrorState(data['data'].entries.first.value[0]));
      }
    } catch (e) {
      emit(RegisterSomeThingWentWrongState());
    }
  }

  void logout() async {
    emit(LogoutLoadingState());
    try {
      String refreshToken = await getStringFromLocal(AppApi.userRefreshToken);
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response response = await http.post(Uri.parse('${AppApi.ipAddress}/users/logout/'), headers: headers, body: json.encode({'refresh_token': refreshToken}));
      var data = json.decode(response.body);
      if (response.statusCode == 205) {
        await clearLocalStore();
        Restart.restartApp();
        emit(LogoutSuccessState());
      } else {
        await clearLocalStore();
        Restart.restartApp();
        emit(LogoutErrorState(data['data']));
      }
    } catch (e) {
      await clearLocalStore();
      Restart.restartApp();
      emit(LogoutSomeThingWentWrongState());
    }
  }

  Future<String> getUserData() async {
    emit(GetUserDataLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/users/user_data/'), headers: headers);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        _userModel = UserModel.fromJson(data['data']);
        if (data['is_phone_verified'] == false) {
          return 'redirectPhone';
        } else {
          return 'home';
        }
      } else {
        return 'welcome';
      }
    } catch (e) {
      emit(GetUserDataSomeThingWentWrongState());
      return 'errorScreen';
    }
  }

  void updateUserData({required String newPhone, required String newEmail, required String newFirstName, required String newLastName, required Map<String, dynamic> newCountry, required bool newIsMale, File? newProfilePicture, required bool newisAcceptNotification}) async {
    emit(UpdateUserDataLoadingState());
    try {
      Map<String, dynamic> toSendData = {};
      if (_userModel!.phone != newPhone) toSendData['phone'] = newPhone;
      if (_userModel!.email != newEmail) toSendData['email'] = newEmail;
      if (_userModel!.firstName != newFirstName) toSendData['first_name'] = newFirstName;
      if (_userModel!.lastName != newLastName) toSendData['last_name'] = newLastName;
      if (_userModel!.country != newCountry['id']) toSendData['country'] = newCountry['id'];
      if (_userModel!.isMale != newIsMale) toSendData['is_male'] = newIsMale;
      if (_userModel!.isAcceptNotification != newisAcceptNotification) toSendData['is_accept_notification'] = newisAcceptNotification;

      var uri = Uri.parse('${AppApi.ipAddress}/users/user_data/');
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll(AppApi.headerData);

      toSendData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (newProfilePicture != null) {
        var picFile = await http.MultipartFile.fromPath(
          'profile_pic',
          newProfilePicture.path,
        );
        request.files.add(picFile);
      }

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = json.decode(responseBody);

      if (response.statusCode == 200) {
        if (_userModel!.phone != newPhone) userModel?.phone = newPhone;
        if (_userModel!.email != newEmail) userModel?.email = newEmail;
        if (_userModel!.firstName != newFirstName) userModel?.firstName = newFirstName;
        if (_userModel!.lastName != newLastName) userModel?.lastName = newLastName;
        if (_userModel!.country != newCountry['id']) userModel?.country = newCountry['id'];
        if (_userModel!.isMale != newIsMale) userModel?.isMale = newIsMale;
        if (_userModel!.isAcceptNotification != newisAcceptNotification) userModel?.isAcceptNotification = newisAcceptNotification;
        emit(UpdateUserDataSuccessState());
      } else {
        emit(UpdateUserDataErrorState(data['data']));
      }
    } catch (e) {
      emit(UpdateUserDataSomeThingWentWrongState());
    }
  }

}