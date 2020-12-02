import 'package:app_cnpm/models/post.dart';
import 'package:app_cnpm/models/posts_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_profile.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPage createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Post ipost,int i) {
    return  Container(
      decoration: BoxDecoration(
        color: i%2==0?Colors.white:Colors.greenAccent,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.only(
          top: 5, bottom: 5, right: 5, left: 5),
      child: ListTile(
        leading: InkWell(onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomProfile(ipost: ipost,)));},child: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(ipost.userImage),
        ),),
        title: Text(ipost.username,style: TextStyle(color: Colors.black),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(ipost.caption,style: TextStyle(color: Colors.black)),
            SizedBox(height: 6.0),
            // Text(
            //   DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
            // ),
          ],
        ),
      ),
    );
  }


  _buildCommentTF() {
    // final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Colors.red
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.length > 0;
                  });
                },
                decoration:
                InputDecoration.collapsed(hintText: 'Write a comment...',hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  // if (_isCommenting) {
                  //   DatabaseService.commentOnPost(
                  //     currentUserId: currentUserId,
                  //     post: widget.post,
                  //     comment: _commentController.text,
                  //   );
                  //   _commentController.clear();
                  //   setState(() {
                  //     _isCommenting = false;
                  //   });
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          '13 Comments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(color: Colors.black87,child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: ( context,  i) {
                return _buildComment(posts[i],i);
              },
            ),
          ),
          Divider(height: 1.0),
          _buildCommentTF(),
        ],
      ),)
    );
  }
}