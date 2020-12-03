class Comment {
  int commentID;
  int authorID;
  int postID;
  String content;

  Comment({this.commentID, this.authorID, this.postID, this.content});

  Comment.fromJson(Map<String, dynamic> json)
      : commentID = json['commentID'],
        authorID = json['authorID'],
        postID = json['postID'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'commentID': commentID,
        'authorID': authorID,
        'postID': postID,
        'content': content,
      };
}
