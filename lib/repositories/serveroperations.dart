import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ServerOperation {
  Future<http.Response> getDataFromServer(String url,/*
      {Map<String, String> headers}*/) async {
    return await http.get(url);
  }

  Future<http.Response> postDataToServer(String url, var json) async {
    return await http.post(
      url,
      headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  Future<http.Response> patchDataToServer(String url, var json) async {
    return await http.patch(
      url,
      headers:  <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );
  }

  Future<http.Response> deleteDataFromServer(String url,/*
      {Map<String, String> headers}*/) async {
    return await http.delete(url);
  }

  Future<bool> checkConnection() async {
    try {
      String url = "http://192.168.1.4:8000";
      final response = await ServerOperation().getDataFromServer(url);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['message'] == 'Server is OK!') {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
