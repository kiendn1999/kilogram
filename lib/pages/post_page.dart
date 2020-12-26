import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:kilogram_app/models/comment.dart';
import 'package:kilogram_app/models/like.dart';
import 'package:kilogram_app/models/post.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/comment_repository.dart';
import 'package:kilogram_app/repositories/like_repository.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'comments_page.dart';
import 'likes_page.dart';

class PostPage extends StatefulWidget {
  Post1 _post1;
  User _user;

  PostPage(this._post1, this._user);

  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  bool _isliked = false;
  bool _isliking = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupIsLiked();
  }

  _setupIsLiked() async {
    bool isLiked = await LikeRepository()
        .checkLiked(widget._post1.postID, UserRepository.getUserID);
    setState(() {
      _isliked = isLiked;
    });
  }

  _LikeOrUnLike() {
    if (_isliked) {
      _unLike();
    } else {
      _like();
    }
  }

  _unLike() async {
    setState(() {
      _isliking = true;
    });
    await LikeRepository()
        .actionUnLike(widget._post1.postID, UserRepository.getUserID);
    setState(() {
      _isliking = false;
      _isliked = false;
    });
  }

  _like() async {
    setState(() {
      _isliking = true;
    });
    await LikeRepository()
        .actionLike(widget._post1.postID, UserRepository.getUserID);

    setState(() {
      _isliking = false;
      _isliked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List avatarbytes = base64Decode(widget._user.avatar);
    Uint8List postImagebytes = base64Decode(widget._post1.postImage);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            'Post',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(600),
                            topLeft: Radius.circular(300),
                            bottomLeft: Radius.circular(300),
                          ),
                        ),
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, right: 60, left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image(
                                image: widget._user.avatar.isEmpty
                                    ? AssetImage("assets/default_avatar.jpg")
                                    : Image.memory(avatarbytes).image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget._user.firstName +
                                " " +
                                widget._user.lastName),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              text: DateFormat.yMMMMd('en_US').add_jm().format(
                                  DateTime.parse(widget._post1.dateCreate)
                                      .toLocal())),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                text: widget._post1.caption)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: FadeInImage(
                          image: Image.memory(postImagebytes).image,
                          placeholder: AssetImage("assets/placeholder.png"),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if (_isliking)
                            Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.redAccent)))
                          else
                            IconButton(
                                onPressed: _LikeOrUnLike,
                                icon: _isliked
                                    ? Icon(
                                        FontAwesome.heart,
                                        color: Colors.redAccent,
                                      )
                                    : Icon(
                                        FontAwesome.heart_o,
                                        color: Colors.white,
                                      )),
                          FutureBuilder<List<LikeUser>>(
                              future: LikeRepository()
                                  .getAllLikeUser(widget._post1.postID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  return InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LikePage(snapshot.data)));
                                      },
                                      child: RichText(
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              text: snapshot.data.length
                                                  .toString()),
                                          TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              text: " Peoples liked this post"),
                                        ]),
                                      ));
                                else
                                  return Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.deepOrange)));
                              })
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              FontAwesome.comment_o,
                              color: Colors.white,
                            ),
                          ),
                          FutureBuilder<List<Comment>>(
                              future: CmtRepository()
                                  .getAllComments(widget._post1.postID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentPage(
                                                        snapshot.data.length,widget._post1.postID)))
                                            .then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: RichText(
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              text: snapshot.data.length
                                                  .toString()),
                                          TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              text: " Comments"),
                                        ]),
                                      ));
                                else
                                  return Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.green)));
                              }),
                        ],
                      ),
                    ],
                  )),
        ));
  }
}
