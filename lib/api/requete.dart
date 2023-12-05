import 'dart:convert';

import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ResponseApi> login(String email, String password) async {
  ResponseApi resposeapi = ResponseApi();
  try {
    final response = await http.post(Uri.parse(loginUrl),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        resposeapi.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        resposeapi.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        resposeapi.error = jsonDecode(response.body)['message'];
        break;
      default:
        resposeapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    resposeapi.error = serverError;
  }
  return resposeapi;
}

Future<ResponseApi> register(String name, String email, String password) async {
  ResponseApi resposeapi = ResponseApi();
  try {
    final response = await http.post(Uri.parse(registerUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });
    switch (response.statusCode) {
      case 200:
        resposeapi.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        resposeapi.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        resposeapi.error = jsonDecode(response.body)['message'];
        break;
      default:
        resposeapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    resposeapi.error = serverError;
  }
  return resposeapi;
}

Future<ResponseApi> getUser() async {
  ResponseApi resposeapi = ResponseApi();
  try {
    String token=await getToken();
    final response = await http.get(Uri.parse(userUrl), headers: {
      'Accept': 'application/json',
      'Authorization':'Bearer $token',
    });
    switch (response.statusCode) {
      case 200:
        resposeapi.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        resposeapi.error = unauthorised;
        break;
      default:
        resposeapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    resposeapi.error = serverError;
  }
  return resposeapi;
}

