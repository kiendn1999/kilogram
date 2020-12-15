import 'dart:convert';
import 'package:kilogram_app/models/post.dart';
import 'package:kilogram_app/models/user.dart';

import 'serveroperations.dart';

class PostRepository{
  Future<List<Post1>> getAllPostsinUser(String userID, int pageKey) async {
    String url = 'http://192.168.31.204:3000/users/$userID/posts?page=$pageKey';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {

      var post1ObjsJson = jsonDecode(response.body)['posts'] as List;
      List<Post1> Post1s = post1ObjsJson.map((post1Json) => Post1.fromJson(post1Json)).toList();

      return Post1s;
    }else throw Exception('Failed to load User');
  }

}