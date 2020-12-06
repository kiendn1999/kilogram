class Follow {
  int followerID;
  int followeeID;


  Follow({this.followerID, this.followeeID});

  Follow.fromJson(Map<String, dynamic> json)
      : followerID = json['followerID'],
        followeeID = json['followeeID'];

  Map<String, dynamic> toJson() => {
    'followerID': followerID,
    'followeeID': followeeID
  };
}