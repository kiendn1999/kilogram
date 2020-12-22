import 'dart:convert';
import 'package:kilogram_app/models/post.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

import 'serveroperations.dart';
import 'user_repository.dart';

class PostRepository{
  String _getPostID;

  Future<List<Post1>> getAllPostsinUser(String userID, int pageKey) async {
    String url = 'https://leanhhuy.herokuapp.com/users/$userID/posts?page=$pageKey';
    final response = await ServerOperation().getDataFromServer(url, UserRepository.token);

    if (response.statusCode == 200) {

      var post1ObjsJson = jsonDecode(response.body)['posts'] as List;
      List<Post1> Post1s = post1ObjsJson.map((post1Json) => Post1.fromJson(post1Json)).toList();

      return Post1s;
    }else throw Exception('Failed to load User');
  }

  Future<String> createAPostInUser(
      String image, String caption, String userID) async {
    final response = await ServerOperation().postDataToServer(
        'https://leanhhuy.herokuapp.com/users/$userID/posts',
        jsonEncode(<String, String>{
          'image': image,
          'description': caption,
        },
        ),UserRepository.token,);

    if (response.statusCode == 201) {
      _getPostID = jsonDecode(response.body)['postID'];
      return "success";
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<Post1> getAPost(String postID) async {
    String url = 'https://leanhhuy.herokuapp.com/posts/$postID';
    final response = await ServerOperation().getDataFromServer(url, UserRepository.token);

    if (response.statusCode == 200) {
      return Post1.fromJson(jsonDecode(response.body)['post']);
    }else throw Exception('Failed to load Post');
  }
  Future<bool> deleteAPost(String postID) async {
    String url = 'https://leanhhuy.herokuapp.com/posts/$postID';
    final response = await ServerOperation().deleteDataFromServer(url,UserRepository.token);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'];
    }else throw Exception('Failed to load Post');
  }
}