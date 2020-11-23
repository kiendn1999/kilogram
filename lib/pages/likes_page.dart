import 'package:app_cnpm/models/posts_data.dart';
import 'package:app_cnpm/pages/custom_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikePage extends StatefulWidget {
  // final DocumentReference documentReference;
  // final User user;
  // LikePage({this.documentReference, this.user});

  @override
  _LikePage createState() => _LikePage();
}

class _LikePage extends State<LikePage> {
  // var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black87,
        title: Text('Likes', style: TextStyle(color: Colors.white),),
      ),
      body: Container(color: Colors.black87,child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 16.0),
            child: ListTile(
              title: GestureDetector(
                onTap: () {
                  // snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: ((context) => InstaProfileScreen())
                  // )) : Navigator.push(context, MaterialPageRoute(
                  //     builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                  // ));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CustomProfile(ipost: posts[index])));
                },
                child: Text(
                  posts[index].username,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  // snapshot.data[index].data['ownerName'] == widget.user.displayName ?
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: ((context) => InstaProfileScreen())
                  // )) : Navigator.push(context, MaterialPageRoute(
                  //     builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                  // ));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CustomProfile(ipost: posts[index])));
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      posts[index].userImage),
                  radius: 30.0,
                ),
              ),
              // trailing:
              //     snapshot.data[index].data['ownerUid'] != widget.user.uid
              //         ? buildProfileButton(snapshot.data[index].data['ownerName'])
              //         : null,
            ),
          );
        }),
      ))
    );
  }
}
