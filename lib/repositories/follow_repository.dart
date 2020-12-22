import 'dart:convert';

import 'serveroperations.dart';

class FollowRepository {
  Future<List<String>> getFollowers(String userID) async {
    final response = await ServerOperation()
        .getDataFromServer("https://leanhhuy.herokuapp.com/users/$userID/follower")
    ;

    if (response.statusCode == 200) {
      List<String> idFollowers = List.from(jsonDecode(response.body)['follower']);
      return idFollowers;
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<List<String>> getFollowings(String userID) async {
    final response = await ServerOperation()
        .getDataFromServer("https://leanhhuy.herokuapp.com/users/$userID/following");

    if (response.statusCode == 200) {
      List<String> idFollowings = List.from(jsonDecode(response.body)['followings']);
      return idFollowings;
    } else
      return jsonDecode(response.body)['error']['message'];
  }

  Future<bool> actionFollow(String ownerID, String guestID) async {
    String url = 'https://leanhhuy.herokuapp.com/users/$ownerID/follower';
    final response = await ServerOperation().postDataToServer(
        url,
        jsonEncode(<String, String>{
          'following': guestID
        }));

    if (response.statusCode == 200)
      return jsonDecode(response.body)['success'];
     else
      throw Exception('Follow is Failed');
  }
  Future<bool> actionUnFollow(String ownerID, String guestID) async {
    String url = 'https://leanhhuy.herokuapp.com/users/$ownerID/following';
    final response = await ServerOperation().postDataToServer(
        url,
        jsonEncode(<String, String>{
          'following': guestID
        }));

    if (response.statusCode == 200)
      return jsonDecode(response.body)['success'];
    else
      throw Exception('Unfollow is Failed');
  }

  Future<bool> checkFollowing(String idOwner, String idUser) async {
    String url = 'https://leanhhuy.herokuapp.com/users/$idOwner/checkfollow/$idUser';
    final response = await ServerOperation().getDataFromServer(url);

    if (response.statusCode == 200)
      return jsonDecode(response.body)['followStatus'];
    return false;
  }

}
