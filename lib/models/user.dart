
class User {
  String userID;
  String lastName;
  String firstName;
  //String userImage;
  String email;
  int followerCount;
  int followeeCount;
  int totalPosts;
  String avatar;


  User({
    this.userID,
    this.lastName,
    this.firstName,
    //this.userImage,
    this.email,
    this.avatar,
    this.totalPosts,
});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['_id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      email: json['email'],
      avatar: json['avatar'],
      totalPosts: json['totalPosts'],
    );
  }

}