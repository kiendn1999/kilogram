import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kilogram_app/models/post.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/pages/post_page.dart';
import 'package:kilogram_app/repositories/follow_repository.dart';
import 'package:kilogram_app/repositories/post_repository.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

import 'followers_page.dart';

class CustomProfile extends StatefulWidget {
  final String customID;

  CustomProfile({this.customID});

  @override
  _CustomProfile createState() => _CustomProfile();
}

class _CustomProfile extends State<CustomProfile> {
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 12;

  final ScrollController _controller = ScrollController();

  List<Post1> _posts = [];
  int _pageKey = 1;
  bool _loading = true;
  bool _canLoadMore = true;
  bool _isFollowing = false;
  bool _isprocess = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _setupIsFollowing();
    _getPosts();
  }

  Future<void> _getPosts() async {
    _loading = true;

    final newPosts =
        await PostRepository().getAllPostsinUser(widget.customID, _pageKey);

    setState(() {
      _posts.addAll(newPosts);

      _pageKey++;

      if (newPosts.length < _itemsPerPage) {
        _canLoadMore = false;
        return false;
      }

      _loading = false;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      _getPosts();
    }
  }

  _setupIsFollowing() async {
    bool isFollowing = await FollowRepository()
        .checkFollowing(UserRepository.getUserID, widget.customID);
    setState(() {
      _isFollowing = isFollowing;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() async {
    setState(() {
      _isprocess = true;
    });
    await FollowRepository()
        .actionUnFollow(UserRepository.getUserID, widget.customID);
    setState(() {
      _isprocess = false;
      _isFollowing = false;
    });
  }

  _followUser() async {
    setState(() {
      _isprocess = true;
    });
    await FollowRepository()
        .actionFollow(UserRepository.getUserID, widget.customID);

    setState(() {
      _isprocess = false;
      _isFollowing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.black87),
      body: Container(
          color: Colors.black87,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              controller: _controller,
              child: FutureBuilder<User>(
                future: UserRepository().getInfoCusTomUser(widget.customID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Uint8List imagebytes = base64Decode(snapshot.data.avatar);
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        //Info
                        Container(
                          height: 290,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.purpleAccent, Colors.pinkAccent],
                          )),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  //avatar
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: Offset(0, 10)),
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: snapshot.data.avatar.isEmpty
                                            ? AssetImage(
                                                "assets/default_avatar.jpg")
                                            : Image.memory(imagebytes).image,
                                        // image: NetworkImage(widget.ipost.userImage)
                                      ),
                                    ),
                                  ),

                                  //username
                                  Text(
                                    snapshot.data.firstName +
                                        ' ' +
                                        snapshot.data.lastName,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  //edit buton
                                  if (_isprocess)
                                    Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.teal)))
                                  else
                                    RaisedButton(
                                        onPressed: _followOrUnfollow,
                                        color: _isFollowing
                                            ? Colors.grey
                                            : Colors.green,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10)),
                                        child: Text(
                                          _isFollowing ? 'Unfollow' : 'Follow',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 3),
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.black87,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10)),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Posts",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.totalPosts
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder<List<String>>(
                                              future: FollowRepository()
                                                  .getFollowers(
                                                      snapshot.data.userID),
                                              builder: (context, snapshot1) {
                                                return Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FollowersPage(
                                                                      isActionFollowers:
                                                                          true,
                                                                      idFollowers:
                                                                          snapshot1
                                                                              .data)));
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Followers",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (snapshot1.hasData)
                                                          Text(
                                                            snapshot1
                                                                .data.length
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        else
                                                          Center(
                                                              child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .redAccent)))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          FutureBuilder<List<String>>(
                                              future: FollowRepository()
                                                  .getFollowings(
                                                      snapshot.data.userID),
                                              builder: (context, snapshot2) {
                                                return Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FollowersPage(
                                                                      isActionFollowers:
                                                                          false,
                                                                      idFollowers:
                                                                          snapshot2
                                                                              .data)));
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Following",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (snapshot2.hasData)
                                                          Text(
                                                            snapshot2
                                                                .data.length
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        else
                                                          Center(
                                                              child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .green)))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Posts
                        Container(
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  //crossAxisCount: 3,
                                  maxCrossAxisExtent: 150,
                                  crossAxisSpacing: 0.2,
                                  mainAxisSpacing: 0.1,
                                ),
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: _posts.length,
                                itemBuilder: (context, i) {
                                  Uint8List imagebytes =
                                      base64Decode(_posts[i].postImage);
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => PostPage(
                                                  _posts[i], snapshot.data)));
                                    },
                                    child: Container(
                                        color: Colors.black87,
                                        child: Image(
                                          image: Image.memory(imagebytes).image,
                                        )),
                                  );
                                })),
                        Container(
                          child: _canLoadMore
                              ? Container(
                                  padding: EdgeInsets.only(bottom: 16),
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blueAccent)),
                                )
                              : SizedBox(),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError)
                    return Text("${snapshot.error}");
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ))),
    );
  }
}
