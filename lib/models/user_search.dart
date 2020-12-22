

class UserSearch {
  String userID;
  String lastName;
  String avatar;


  UserSearch({
    this.userID,
    this.lastName,
    this.avatar
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      userID: json['_id'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }

}