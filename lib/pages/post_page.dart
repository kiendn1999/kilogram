
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../models/posts_data.dart';
import 'comments_page.dart';
import 'likes_page.dart';

class PostPage extends StatefulWidget {
  final Post post;

  PostPage({this.post});

  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  bool _liked=false;
  @override
  Widget build(BuildContext context) {
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
                                image: NetworkImage(widget.post.userImage),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Huy"),
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
                              text: "${widget.post.date}"),
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
                                text: " ${widget.post.caption}")),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: FadeInImage(
                          image: NetworkImage(widget.post.postImage),
                          placeholder: AssetImage("assets/placeholder.png"),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              setState(() => this._liked = !this._liked);
                            },
                            icon: this._liked
                                ? Icon(
                              FontAwesome.heart,
                              color: Colors.redAccent,
                            )
                                : Icon(
                              FontAwesome.heart_o,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LikePage()));},child: RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  text: "Liked by "),
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text: "Huy "),
                            ]),
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CommentPage()));
                            },
                            icon: Icon(
                              FontAwesome.comment_o,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  text: "11 "),
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  text: "comments"),
                            ]),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         FontAwesome.edit,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     RichText(
                      //         softWrap: true,
                      //         overflow: TextOverflow.visible,
                      //         text: TextSpan(
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //             ),
                      //             text: "Edit")),
                      //   ],
                      // ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return ClassicGeneralDialogWidget(
                                    titleText: 'Delete post ?',
                                    contentText:
                                        "Would you like to cotinue deleting this post ?",
                                    onPositiveClick: () {
                                      Navigator.of(context).pop();
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
                            icon: Icon(
                              FontAwesome.trash_o,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                text: "Delete"),
                          ),
                        ],
                      )
                    ],
                  )),
        ));
  }
}
