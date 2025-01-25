import 'package:shared_preferences/shared_preferences.dart';


Future<String> getStringFromLocal(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? value = sharedPreferences.getString(key);
  if (value == null) {
    return '';
  }
  return value;
}

Future<void> saveStringToLocal(String key, String value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(key, value);
}

Future<void> saveBoolToLocal(String key, bool value) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool(key, value);
}

Future<bool> getBoolFromLocal(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool? value = sharedPreferences.getBool(key);
  if (value == null) {
    return false;
  }
  return value;
}

Future<void> clearLocalStore() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}