class FollowCount {
  int totalFollower;
  int totalFollowing;

  FollowCount({this.totalFollower, this.totalFollowing});

  factory FollowCount.fromJson(Map<String, dynamic> json) {
    return FollowCount(
      totalFollower: json['totalFollower'],
      totalFollowing: json['totalFollowing'],
    );
  }
}
