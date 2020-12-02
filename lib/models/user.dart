import 'Post.dart';

class User {
  String id;
  String username;
  String userImage;
  String email;
  String password;
  List<Post> posts = new List();


  User({
    this.id,
    this.username,
    this.userImage,
    this.email,
    this.password,

});
}