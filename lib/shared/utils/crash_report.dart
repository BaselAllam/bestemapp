// import 'dart:io';
// import 'package:superhero/shared/utils/app_assets.dart';
// import 'package:superhero/shared/utils/local_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// Future<void> createCrash({required String errorMsg, required String endpointName}) async {
//   try {
//     String userToken = await getStringFromLocal(AppAssets.userToken);
//     Map<String, String> headers = AppAssets.headerData;
//     headers['Authorization'] = 'Bearer $userToken';
//     Map<String, dynamic> newData = {
//       'error_message': errorMsg,
//       'endpoint_name': endpointName,
//       'platform': Platform.isAndroid ? 'android' : 'ios'
//     };
//     http.Response response = await http.post(Uri.parse('${AppAssets.serverDomain}/crash-report/create-crash/'), headers: headers, body: json.encode(newData));
//   } catch (e) {}
// }