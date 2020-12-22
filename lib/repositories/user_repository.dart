import 'dart:convert';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/models/user_search.dart';

import 'serveroperations.dart';

class UserRepository {
  bool isLogined = false;
  static String  getUserID;

  //CustomCacheManager customCacheManager = CustomCacheManager();

  UserRepository() {}

  Future<String> registerUser(
      String lastName, String firstName, String email, String password) async {
    final response = await ServerOperation().postDataToServer(
        'http://192.168.1.4:8000/users/signup',
        jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password
        }));

    if (response.statusCode == 201) {
      getUserID = jsonDecode(response.body)['_id'];
      return "true";
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<String> checkLoginCredentials(String email, String password) async {
    String url = 'http://192.168.1.4:8000/users/signin';

    final response = await ServerOperation().postDataToServer(
      url,
      jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['_id'] != null) {
      isLogined = true;
      getUserID = jsonDecode(response.body)['_id'];
      return "true";
    }
    return jsonDecode(response.body)['error']['message'];
  }

  Future<User> getInfoUser() async {
    String url = 'http://192.168.1.4:8000/users/$getUserID';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else
      throw Exception('Failed to load User');
  }

  Future<User> getInfoCusTomUser(String customID) async {
    String url = 'http://192.168.1.4:8000/users/$customID';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['user']);
    } else
      throw Exception('Failed to load User');
  }

  Future<List<UserSearch>> searchUser(String key, int pageKey) async {
    final response = await ServerOperation().postDataToServer(
        'http://192.168.1.4:8000/users/search?page=$pageKey',
        jsonEncode(<String, String>{
          'userName': key,
        }));

    if (response.statusCode == 200) {
      var userObjsJson = jsonDecode(response.body)['found'] as List;
      List<UserSearch> Users = userObjsJson.map((userJson) => UserSearch.fromJson(userJson)).toList();

      return Users;
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<String> updateUser( String firstName, String lastName, String email, String avatar, String userID) async {
    final response = await ServerOperation().patchDataToServer(
        'http://192.168.1.4:8000/users/$userID',
        jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'avatar': avatar,
        }));
    if (response.statusCode == 200) {

      return 'success';
    }else throw Exception('Failed to update User');

  }
}
