import 'dart:convert';

import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/models/posts.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ResponseApi> getPost() async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(postsUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body)['posts']
            .map((p) => Post.fromJson(p))
            .toList();
        responseapi.data as List<dynamic>;
        break;
      case 401:
        responseapi.error = unauthorised;
        break;
      default:
        responseapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    responseapi.error = serverError;
  }
  return responseapi;
}

Future<ResponseApi> storePost(String body, String? image) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(postsUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null
            ? {'body': body, 'image': image}
            : {
                'body': body,
              });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        responseapi.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        responseapi.error = unauthorised;
        break;
      default:
        responseapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    responseapi.error = serverError;
  }
  return responseapi;
}

Future<ResponseApi> editPost(int postId, String body) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$postsUrl/$postId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'body': body,
    });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        responseapi.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        responseapi.error = unauthorised;
        break;
      default:
        responseapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    responseapi.error = serverError;
  }
  return responseapi;
}

Future<ResponseApi> removePost(int postId) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$postsUrl/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        responseapi.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        responseapi.error = unauthorised;
        break;
      default:
        responseapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    responseapi.error = serverError;
  }
  return responseapi;
}

Future<ResponseApi> likePost(int postId) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsUrl/$postId/likes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        responseapi.error = unauthorised;
        break;
      default:
        responseapi.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    responseapi.error = serverError;
  }
  return responseapi;
}

