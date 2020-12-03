import 'dart:convert';

import 'user.dart';
class Post {
  int postID;
  int authorID;
  String postImage;
  int likeCount;
  int cmtCount;
  String caption;
  String date;

  // String userImage;
  // String username;
  List<Like> likes = new List();
  List<Comment> comments = new List();

  Post({
    this.postID,
    this.authorID,
    this.postImage,
    this.caption,
    this.likeCount,
    this.cmtCount,
    this.date,

    // this.userImage,
    // this.username,

});
  Post.fromJson(Map<String, dynamic> json):
        postID = json['postID'],
        authorID = json['authorID'],
        postImage = json['postImage'],
        likeCount = json['likeCount'],
        cmtCount = json['cmtCount'],
        caption = json['caption'],
        date = json['date'];



  Map<String, dynamic> toJson() => {
    'postID': postID,
    'authorID': authorID,
    'postImage': postImage,
    'likeCount': likeCount,
    'cmtCount': cmtCount,
    'caption': caption,
    'date': date
  };

}