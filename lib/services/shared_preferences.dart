import 'package:shared_preferences/shared_preferences.dart';

Future<String>getToken()async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int>getUserId()async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool>logout()async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  return pref.remove('token');
}