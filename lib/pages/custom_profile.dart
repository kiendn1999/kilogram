import 'package:app_cnpm/models/post.dart';
import 'package:app_cnpm/models/posts_data.dart';
import 'package:app_cnpm/pages/post_page.dart';
import 'package:flutter/material.dart';

import 'followers_page.dart';
import 'follows_page.dart';

class CustomProfile extends StatefulWidget {
  final Post ipost;

  CustomProfile({this.ipost});

  @override
  _CustomProfile createState() => _CustomProfile();
}

class _CustomProfile extends State<CustomProfile> {
  bool _Follow = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.ipost.username), backgroundColor: Colors.black87),
      body: Container(
          color: Colors.black87,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => Column(
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
                                        image: NetworkImage(
                                            "https://upload.wikimedia.org/wikipedia/commons/a/a0/Pierre-Person.jpg")
                                        // image: NetworkImage(widget.ipost.userImage)
                                        ),
                                  ),
                                ),

                                //Follow button
                                RaisedButton(
                                  onPressed: () {
                                    setState(
                                        () => this._Follow = !this._Follow);
                                  },
                                  color: this._Follow
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10)),
                                  child: this._Follow
                                      ? Text(
                                          'Follow',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          'Unfollow',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),

                                //username
                                Text(
                                  widget.ipost.username,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.black87,
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
                                                "5",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowersPage()));
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
                                                  Text(
                                                    "5",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowsPage()));
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "5",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
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
                              itemCount: posts.length,
                              itemBuilder: (context, i) => InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => PostPage(
                                                    post: posts[i],
                                                  )));
                                    },
                                    child: Container(
                                        color: Colors.black87,
                                        child: Image(
                                          image: NetworkImage(
                                            posts[i].postImage,
                                          ),
                                        )),
                                  ))),
                    ],
                  ))),
    );
  }
}
