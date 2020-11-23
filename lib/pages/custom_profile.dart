import 'package:app_cnpm/models/Post.dart';
import 'package:app_cnpm/models/posts_data.dart';
import 'package:app_cnpm/pages/post_page.dart';
import 'package:flutter/material.dart';

class CustomProfile extends StatefulWidget {
  final Post ipost;

  CustomProfile({this.ipost});

  @override
  _CustomProfile createState() => _CustomProfile();
}

class _CustomProfile extends State<CustomProfile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.ipost.username), backgroundColor: Colors.black87),
      body: Container(
        color: Colors.black87,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(itemCount: 1,itemBuilder: (context,i)=>Column(
          children: <Widget>[
            //Info
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purpleAccent, Colors.pinkAccent],
                  )),
              child: Container(
                width: double.infinity,
                height: 250.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //avatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.ipost.userImage),
                        radius: 45,
                      ),

                      //username
                      Text(
                        widget.ipost.username,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black,
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
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostPage(
                              post: posts[i],
                            )));
                      },
                      child: Container(
                          color: Colors.black,
                          child: Image(
                            image: NetworkImage(
                              posts[i].postImage,
                            ),
                          )),
                    ))),
          ],
        ))
      ),
    );
  }
}
