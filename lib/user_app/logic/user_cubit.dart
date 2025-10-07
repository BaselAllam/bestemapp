import 'dart:developer';

import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:bestemapp/user_app/logic/user_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserCubit extends Cubit<UserStates> {

  UserCubit() : super(InitialUserState());

  Future<void> login(String phone, String password) async {
    emit(LoginLoadingState());
    try {
      http.Response response = await http.post(Uri.parse('${AppApi.ipAddress}/users/login/'), headers: AppApi.headerData, body: json.encode({'phone': phone, 'password': password}));
      log(response.body);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        await saveBoolToLocal(AppApi.isLoggedIn, true);
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
      log(e.toString());
      emit(LoginSomeThingWentWrongState());
    }
  }
}