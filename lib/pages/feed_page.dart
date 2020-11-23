import 'package:app_cnpm/models/posts_data.dart';
import 'package:app_cnpm/pages/comments_page.dart';
import 'package:app_cnpm/pages/custom_profile.dart';
import 'package:app_cnpm/pages/likes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, i) => Container(
            color: Colors.black87,
            child: Column(
              children: <Widget>[
                if (i % 2 == 0) ...[
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CustomProfile(
                                      ipost: posts[i],
                                    )));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image(
                              image: NetworkImage(posts[i].userImage),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(posts[i].username),
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
                          text: "${posts[i].date}"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: RichText(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            text: " ${posts[i].caption}")),
                  ),
                ] else ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(600),
                        topRight: Radius.circular(300),
                        bottomRight: Radius.circular(300),
                      ),
                    ),
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 60, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(posts[i].username),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CustomProfile(
                                      ipost: posts[i],
                                    )));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image(
                              image: NetworkImage(posts[i].userImage),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.topRight,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          text: "${posts[i].date}"),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: RichText(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            text: " ${posts[i].caption}")),
                  ),
                ],
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: FadeInImage(
                    image: NetworkImage(posts[i].postImage),
                    placeholder: AssetImage("assets/placeholder.png"),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                if (i % 2 == 0) ...[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesome.heart_o,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LikePage()));
                        },
                        child: RichText(
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
                        ),
                      )
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
                  )
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LikePage()));
                          },
                          child: RichText(
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
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesome.heart_o,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                              text: "comments "),
                        ]),
                      ),
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
                    ],
                  )
                ],
              ],
            ),
          ),
        ));
  }
}
