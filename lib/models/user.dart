import 'package:app_cnpm/models/post.dart';

import 'Post.dart';

class User {
  String id;
  String username;
  String userImage;
  String email;
  String password;
  int followerCount;
  int followeeCount;

  List<Post> posts = new List();
  List<Comment> comments = new List();
  List<Follow> followers = new List();
  List<Follow> followees = new List();



  User({
    this.id,
    this.username,
    this.userImage,
    this.email,
    this.password,
    this.followerCount,
    this.followeeCount
});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        userImage = json['userImage'],
        email = json['email'],
        password = json['password'],
        followerCount = json['followerCount'],
        followeeCount = json['followeeCount'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'userImage': userImage,
    'email': email,
    'password': password,
    'followerCount': followerCount,
    'followeeCount': followeeCount,
  };
}