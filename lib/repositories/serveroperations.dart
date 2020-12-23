import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kilogram_app/repositories/user_repository.dart';

class ServerOperation {
  Future<http.Response> getDataFromServer(String url) async {
    return await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: UserRepository.token
      },
    );
  }

  Future<http.Response> postDataToServer(String url, var json) async {
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: UserRepository.token
      },
      body: json,
    );
  }

  Future<http.Response> postDataToServerforSignin(String url, var json) async {
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  Future<http.Response> patchDataToServer(String url, var json) async {
    return await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: UserRepository.token
      },
      body: json,
    );
  }

  Future<http.Response> deleteDataFromServer(String url) async {
    return await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: UserRepository.token
      },
    );
  }
}
