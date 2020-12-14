import 'follow.dart';
import 'post.dart';
import 'comment.dart';

class User {
  String userID;
  String lastName;
  String firstName;
  //String userImage;
  String email;
  //String password;
  int followerCount;
  int followeeCount;
  String avatar;

  List<Post1> posts = new List();
  List<Comment> comments = new List();
  List<Follow> followers = new List();
  List<Follow> followees = new List();



  User({
    this.userID,
    this.lastName,
    this.firstName,
    //this.userImage,
    this.email,
    this.avatar
    //this.password,
    // this.followerCount,
    // this.followeeCount
});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['_id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }



  Map<String, dynamic> toJson() => {
    'userID': userID,
    'lastName': lastName,
    'firstName': firstName,
    //'userImage': userImage,
    'email': email,
    'avatar': avatar,
    //'password': password,
    // 'followerCount': followerCount,
    // 'followeeCount': followeeCount,
  };
}