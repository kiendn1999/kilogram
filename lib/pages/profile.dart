import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:kilogram_app/models/post.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/follow_repository.dart';
import 'edit_profile.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:kilogram_app/repositories/post_repository.dart';

import 'followers_page.dart';
import 'post_page.dart';

bool isUpdate=false;
class Profile extends StatefulWidget {
  final UserRepository _userRepository;

  const Profile({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 12;
  bool refresh=false;

  final ScrollController _controller = ScrollController();

  List<Post1> _posts = [];
  int _pageKey = 1;
  bool _loading = true;
  bool _canLoadMore = true;
  int _totalPost;



  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _getPosts();
    _gettotalPost();
  }

  _gettotalPost() async {
    User owner=await widget._userRepository.getInfoUser();
    _totalPost=owner.totalPosts;
  }

  Future<void> _getPosts() async {
    _loading = true;

    final newPosts = await PostRepository().getAllPostsinUser(UserRepository.getUserID, _pageKey);

    setState(() {
      _posts.addAll(newPosts);

      _pageKey++;

      if (newPosts.length < _itemsPerPage ) {
        _canLoadMore = false;
        return false;
      }

      _loading = false;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading ) return;

    final thresholdReached = _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      _getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black87,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
          controller: _controller,
          child: FutureBuilder<User>(
            future:UserRepository().getInfoUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Uint8List imagebytes = base64Decode(snapshot.data.avatar);
                return Column(
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
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10)),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: snapshot.data.avatar.isEmpty
                                        ? AssetImage("assets/default_avatar.jpg")

                                        : Image.memory(imagebytes).image,
                                  ),
                                ),
                              ),

                              //username
                              Text(
                                snapshot.data.firstName + ' ' + snapshot.data.lastName,
                                style: TextStyle(fontSize: 22, color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //edit buton
                              RaisedButton(
                                onPressed: ()  {
                                    Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                         snapshot.data))).then((value) {
                                           setState(() {
                                           });
                                    });
                                },
                                color: Colors.red,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10)),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.black87,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10)),
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
                                            Text(_totalPost.toString(),
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
                                                                      .data))).then((value) {
                                                                        setState(() {

                                                                        });
                                                  });
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
                                                          child:
                                                          CircularProgressIndicator())
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
                                                                      .data))).then((value) {
                                                                        setState(() {

                                                                        });
                                                  });
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
                                                          child:
                                                          CircularProgressIndicator())
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
                              Uint8List imagebytes = base64Decode(
                                  _posts[i].postImage);
                              return InkWell(
                                onLongPress: (){
                                  showAnimatedDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return ClassicGeneralDialogWidget(
                                        titleText: 'Delete post ?',
                                        contentText:
                                        "Would you like to cotinue deleting this post ?",
                                        onPositiveClick: () async {
                                          await PostRepository().deleteAPost(_posts[i].postID);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _totalPost--;
                                            _posts.remove(_posts[i]);
                                          });
                                        },
                                        onNegativeClick: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                    animationType: DialogTransitionType.slideFromTop,
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(seconds: 1),
                                  );
                                },
                                onTap: () {
                                   Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostPage(_posts[i],snapshot.data)));
                                },
                                child: Container(
                                    color: Colors.black87,
                                    child: Image(
                                      image: Image.memory(imagebytes)
                                          .image,
                                    )),
                              );
                            })),
                    Container(
                      child: _canLoadMore
                          ? Container(
                        padding: EdgeInsets.only(bottom: 16),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                          : SizedBox(),
                    ),
                  ],
                );
              } else if (snapshot.hasError) return Text("${snapshot.error}");
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
