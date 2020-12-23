class CommentResult {
  String content;
  String commentID;

  CommentResult({this.content, this.commentID});

  factory CommentResult.fromJson(Map<String, dynamic> json) {
    return CommentResult(
      content: json['commented'],
      commentID: json['_id'],
    );
  }
}
