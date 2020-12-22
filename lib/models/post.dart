

class Post1 {
  String postID;
  String authorID;
  String postImage;
  int likeCount;
  int cmtCount;
  String caption;
  String dateCreate;


  Post1({
    this.postID,
    this.authorID,
    this.postImage,
    this.caption,
    this.likeCount,
    this.cmtCount,
    this.dateCreate
  });

  factory Post1.fromJson(Map<String, dynamic> json) {
    return Post1(
        postID: json['_id'],
        authorID: json['owner'],
        postImage: json['image'],
        dateCreate: json['dateCreate'],
        likeCount: json['totalLike'],
        cmtCount: json['totalComment'],
        caption: json['description']);
  }

}
