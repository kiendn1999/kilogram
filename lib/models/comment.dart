
class Comment {
  String userID;
  String lastName;
  String firstName;
  String avatar;
  String dateCmt;
  String content;
  String commentID;


  Comment({this.userID, this.lastName, this.firstName, this.avatar, this.dateCmt,
    this.content, this.commentID});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userID: json['_id'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      avatar: json['avatar'],
      dateCmt: json['dateComment'],
      content: json['commented'],
      commentID: json['commentID'],
    );
  }

}