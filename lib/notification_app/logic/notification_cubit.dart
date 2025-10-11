import 'package:bestemapp/notification_app/logic/notification_states.dart';
import 'package:bestemapp/shared/utils/app_api.dart';
import 'package:bestemapp/shared/utils/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationCubit extends Cubit<NotificationState> {

  NotificationCubit() : super(NotificationInitState());

  // Future<bool> generateFCMToken() async {
  //   try{
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;
  //     String? fcmToken = await messaging.getToken();
  //     if (fcmToken == null) {
  //       return false;
  //     }
  //     // String userToken = await getStringFromLocal(AppAssets.userToken);
  //     // Map<String, String> headers = AppAssets.headerData;
  //     // headers['Authorization'] = 'Bearer $userToken';
  //     // http.Response response = await http.post(Uri.parse('${AppAssets.serverIP}/notifications/save-user-fcm-token/'), headers: headers, body: json.encode({'FCM_Token': fcmToken}));
  //     // if (response.statusCode != 200) {
  //     //   return false;
  //     // } else {
  //     //   await saveStringToLocal(AppAssets.fcmToken, fcmToken);
  //     //   return true;
  //     // }
  //     return true;
  //   } catch (e) {
  //     // await createCrash(errorMsg: e.toString(), endpointName: 'user/generateFCMToken (internal method)');
  //     return false;
  //   }
  // }

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;
  int _unreadNotification = 0;
  int get unreadNotification => _unreadNotification;

  Future<void> getUserNotification() async {
    _notifications.clear();
    emit(GetUserNotificationLoadingState());
    try {
      String userToken = await getStringFromLocal(AppApi.userToken);
      Map<String, String> headers = AppApi.headerData;
      headers['Authorization'] = 'Bearer $userToken';
      http.Response response = await http.get(Uri.parse('${AppApi.ipAddress}/notifications/notifications/'), headers: headers);
      var resData = json.decode(response.body);
      if (response.statusCode != 200) {
        emit(GetUserNotificationErrorState(resData['data']));
      } else {
        for (var i in resData['data']) {
          if (!i['is_read']) {
            _unreadNotification++;
          }
          _notifications.add(i);
        }
        emit(GetUserNotificationSuccessState());
      }
    } catch (e) {
      emit(GetUserNotificationSomeThingWentWrongState());
    }
  }

  Future<void> markNotificationRead() async {
    emit(MarkNotificationReadLoadingState());
    String userToken = await getStringFromLocal(AppApi.userToken);
    Map<String, String> headers = AppApi.headerData;
    headers['Authorization'] = 'Bearer $userToken';
    try {
      http.Response response = await http.put(Uri.parse('${AppApi.ipAddress}/notifications/notifications/'), headers: headers);
      var resData = json.decode(response.body);
      if (response.statusCode != 200) {
        emit(MarkNotificationReadErrorState(resData.toString()));
      } else {
        for (int i = 0; i < _notifications.length; i++) {
          _notifications[i]['is_read'] = true;
        }
        _unreadNotification = 0;
        emit(MarkNotificationReadSuccessState());
      }
    } catch (e) {
      emit(MarkNotificationReadSomeWentWrongState());
    }
  }

}