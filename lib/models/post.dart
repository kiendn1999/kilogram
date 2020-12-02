class Post {
  int postID;
  int authorID;

  String userImage;
  String username;

  String postImage;
  int likeCount;
  int cmtCount;
  String caption;
  String date;

  List<String> comments = new List();

  Post({
    this.postID,
    this.authorID,

    // this.userImage,
    // this.username,

    this.postImage,
    this.caption,
    this.likeCount,
    this.cmtCount,
    this.date
});
}