import 'dart:convert';

import 'package:kilogram_app/models/like.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

import 'serveroperations.dart';

class LikeRepository{
  Future<bool> actionLike(String postIsLiked, String userLiked) async {
    String url = 'http://192.168.1.136:8000/likes';
    final response = await ServerOperation().postDataToServer(
        url,
        jsonEncode(<String, String>{
          'userLiked': userLiked,
          'postIsLiked': postIsLiked
        }),UserRepository.token);

    if (response.statusCode == 201)
      return true;
    else
      throw Exception('Follow is Failed');
  }
  Future<String> actionUnLike(String postIsLiked, String userLiked) async {
    String url = 'http://192.168.1.136:8000/likes/dislike';
    final response = await ServerOperation().postDataToServer(
        url,
        jsonEncode(<String, String>{
          'userLiked': userLiked,
          'postIsLiked': postIsLiked
        }),UserRepository.token);

    if (response.statusCode == 201)
      return jsonDecode(response.body)['status'];
    else
      throw Exception('Unfollow is Failed');
  }

  Future<List<LikeUser>> getAllLikeUser(String idPost) async {
    String url = 'http://192.168.1.136:8000/posts/$idPost/likes';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {

      var likeObjsJson = jsonDecode(response.body)['user'] as List;
      List<LikeUser> LikeUsers = likeObjsJson.map((likeJson) => LikeUser.fromJson(likeJson)).toList();

      return LikeUsers;
    }else throw Exception('Failed to load User');
  }

  Future<bool> checkLiked(String postIsLiked, String userLiked) async {
    String url = 'http://192.168.1.136:8000/posts/$postIsLiked/likes/$userLiked';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200)
      return jsonDecode(response.body)['likeStatus'];
    return false;
  }

}
