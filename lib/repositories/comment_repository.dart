import 'dart:convert';

import 'package:kilogram_app/models/cmtcreate.dart';
import 'package:kilogram_app/models/comment.dart';

import 'serveroperations.dart';
import 'user_repository.dart';

class CmtRepository{
  Future<List<Comment>> getAllComments(String idPost) async {
    String url = 'http://192.168.1.136:8000/posts/$idPost/comments';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {

      var cmt1ObjsJson = jsonDecode(response.body)['user'] as List;
      List<Comment> Comments = cmt1ObjsJson.map((cmtJson) => Comment.fromJson(cmtJson)).toList();

      return Comments;
    }else throw Exception('Failed to load User');
  }
  Future<List<Comment>> getCommentsPage(String idPost, int page) async {
    String url = 'http://192.168.1.136:8000/posts/$idPost/comments?page=$page';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {

      var cmt1ObjsJson = jsonDecode(response.body)['user'] as List;
      List<Comment> Comments = cmt1ObjsJson.map((cmtJson) => Comment.fromJson(cmtJson)).toList();

      return Comments;
    }else throw Exception('Failed to load User');
  }

  Future<CommentResult> creteComment(
      String idPost, String content, String idUser) async {
    final response = await ServerOperation().postDataToServer(
        'http://192.168.1.136:8000/comments',
        jsonEncode(<String, String>{
          'postWasCommented': idPost,
          'commented': content,
          'userCommented': idUser,
        }),UserRepository.token);

    if (response.statusCode == 201) {
      return CommentResult.fromJson(jsonDecode(response.body)['comment']);
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<bool> deleteACmt(String cmtID) async {
    String url = 'http://192.168.1.136:8000/comments/$cmtID';
    final response = await ServerOperation().deleteDataFromServer(url,UserRepository.token);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'];
    }else throw Exception('Failed to load Post');
  }

}