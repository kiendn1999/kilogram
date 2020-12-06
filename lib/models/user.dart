import 'follow.dart';
import 'post.dart';
import 'comment.dart';

class User {
  int userID;
  String lastName;
  String firstName;
  String userImage;
  String email;
  String password;
  int followerCount;
  int followeeCount;

  List<Post1> posts = new List();
  List<Comment> comments = new List();
  List<Follow> followers = new List();
  List<Follow> followees = new List();



  User({
    this.userID,
    this.lastName,
    this.firstName,
    this.userImage,
    this.email,
    this.password,
    this.followerCount,
    this.followeeCount
});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        userID: parsedJson['userID'],
        lastName: parsedJson['lastName'].toString(),
        firstName: parsedJson['firstName'].toString(),
        email: parsedJson['email'].toString(),
        password: parsedJson['password'].toString(),
        followerCount: parsedJson['password'],
        followeeCount: parsedJson['followeeCount']);
  }

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'lastName': lastName,
    'firstName': firstName,
    'userImage': userImage,
    'email': email,
    'password': password,
    'followerCount': followerCount,
    'followeeCount': followeeCount,
  };
}