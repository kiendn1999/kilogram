import 'dart:convert';

import 'package:kilogram_app/models/cmtcreate.dart';
import 'package:kilogram_app/models/comment.dart';

import 'serveroperations.dart';

class CmtRepository {
  Future<List<Comment>> getAllComments(String idPost) async {
    String url = 'https://leanhhuy.herokuapp.com/posts/$idPost/comments';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {
      var cmt1ObjsJson = jsonDecode(response.body)['user'] as List;
      List<Comment> Comments =
          cmt1ObjsJson.map((cmtJson) => Comment.fromJson(cmtJson)).toList();

      return Comments;
    } else
      throw Exception('Failed to load User');
  }

  Future<List<Comment>> getCommentsPage(String idPost, int page) async {
    String url =
        'https://leanhhuy.herokuapp.com/posts/$idPost/comments?page=$page';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200) {
      var cmt1ObjsJson = jsonDecode(response.body)['user'] as List;
      List<Comment> Comments =
          cmt1ObjsJson.map((cmtJson) => Comment.fromJson(cmtJson)).toList();

      return Comments;
    } else
      throw Exception('Failed to load User');
  }

  Future<CommentResult> creteComment(
      String idPost, String content, String idUser) async {
    final response = await ServerOperation().postDataToServer(
        'https://leanhhuy.herokuapp.com/comments',
        jsonEncode(<String, String>{
          'postWasCommented': idPost,
          'commented': content,
          'userCommented': idUser,
        }));

    if (response.statusCode == 201) {
      return CommentResult.fromJson(jsonDecode(response.body)['comment']);
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<bool> deleteACmt(String cmtID) async {
    String url = 'https://leanhhuy.herokuapp.com/comments/$cmtID';
    final response = await ServerOperation().deleteDataFromServer(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'];
    } else
      throw Exception('Failed to load Post');
  }
}
