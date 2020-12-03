class Like {
  int authorID;
  int postID;

  Like({this.authorID, this.postID});

  Like.fromJson(Map<String, dynamic> json)
      : authorID = json['authorID'],
        postID = json['postID'];

  Map<String, dynamic> toJson() => {
        'authorID': authorID,
        'postID': postID,
      };
}
