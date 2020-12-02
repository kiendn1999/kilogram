class Post {
  int id;

  String userImage;
  String username;

  String postImage;
  int likeCount;
  int cmtCount;
  String caption;
  String date;

  List<String> comments = new List();

  Post({
    this.id,

    this.userImage,
    this.username,

    this.postImage,
    this.caption,
    this.likeCount,
    this.cmtCount,
    this.date
});
}