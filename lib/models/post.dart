import 'comment.dart';
import 'like.dart';

class Post1 {
  String postID;
  String authorID;
  String postImage;
  int likeCount;
  int cmtCount;
  String caption;

  //String date;

  // String userImage;
  // String username;
  // List<Like> likes = new List();
  // List<Comment> comments = new List();

  Post1({
    this.postID,
    this.authorID,
    this.postImage,
    this.caption,
    this.likeCount,
    this.cmtCount,
    //this.date,

    // this.userImage,
    // this.username,
  });

  factory Post1.fromJson(Map<String, dynamic> json) {
    return Post1(
        postID: json['_id'],
        authorID: json['owner'],
        postImage: json['image'],
        likeCount: json['totalLike'],
        cmtCount: json['totalComment'],
        caption: json['description']);
  }

  // Map<String, dynamic> toJson() => {
  //       'postID': postID,
  //       'authorID': authorID,
  //       'postImage': postImage,
  //       'likeCount': likeCount,
  //       'cmtCount': cmtCount,
  //       'caption': caption,
  //       //'date': date
  //     };
}
