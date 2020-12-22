class LikeUser {
  String userID;
  String lastName;
  String firstName;
  String avatar;

  LikeUser({this.userID, this.lastName, this.firstName, this.avatar});

  factory LikeUser.fromJson(Map<String, dynamic> json) {
    return LikeUser(
      userID: json['_id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      avatar: json['avatar'],
    );
  }

}
