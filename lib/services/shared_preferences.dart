import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences pref = Preferences._();
  static SharedPreferences? instance;
  Preferences._();
 static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }

  void reset() {
    instance?.clear();
  }

  Future<void> login() async {
    await instance?.setBool("login", true);
  }

  bool? get getLogin {
    return instance?.getBool("login") ?? false;
  }

  Future<void> logout() async {
    await instance?.setBool("login", false);
  }

  bool? get getLogout {
    return instance?.getBool("login") ?? false;
  }
}
 
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}
String? getStringImage(File file){
// ignore: unnecessary_null_comparison
if (file == null) return null;
return base64Encode(file.readAsBytesSync());
}
