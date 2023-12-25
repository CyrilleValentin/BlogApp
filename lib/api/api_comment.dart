import 'dart:convert';

import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/models/comments.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ResponseApi> getComments(int postId) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$postsUrl/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body)['comments']
            .map((p) => Comment.fromJson(p))
            .toList();
        responseapi.data as List<dynamic>;
        break;
      case 403:
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


Future<ResponseApi> createComments(int postId ,String? comments) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsUrl/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },body: {
          'comment':comments
        });
    switch (response.statusCode) {
      case 200:
        responseapi.data = jsonDecode(response.body);
        break;
      case 403:
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
Future<ResponseApi> removeComment(int commentId) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$commentsUrl/$commentId'),
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

Future<ResponseApi> editComments(int commentId, String comment) async {
  ResponseApi responseapi = ResponseApi();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$commentsUrl/$commentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'comment': comment, 
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



