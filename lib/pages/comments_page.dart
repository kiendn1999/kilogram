import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:kilogram_app/models/cmtcreate.dart';
import 'package:kilogram_app/models/comment.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/comment_repository.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

import 'custom_profile.dart';

class CommentPage extends StatefulWidget {
  String _idPost;

  CommentPage(this._idPost);

  @override
  _CommentPage createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage> {
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 10;

  final ScrollController _controller = ScrollController();
  User _owner;

  List<Comment> _comments = [];
  int _pageKey = 1;
  bool _loading = true;
  bool _canLoadMore = true;

  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  bool _isUpdate=false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _getComments();
    _getMyInfo();
  }

  Future<void> _getMyInfo() async {
    _owner = await UserRepository().getInfoUser();
  }

  Future<void> _getComments() async {
    _loading = true;

    final newCmts =
        await CmtRepository().getCommentsPage(widget._idPost, _pageKey);

    setState(() {
      _comments.addAll(newCmts);

      _pageKey++;

      if (newCmts.length < _itemsPerPage) {
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
      _getComments();
    }
  }

  _buildComment(Comment comment, int i) {
    Uint8List imagebytes = base64Decode(comment.avatar);
    return InkWell(
      onLongPress: (){
        if(comment.userID!=UserRepository.getUserID) return ;
        showAnimatedDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return ClassicGeneralDialogWidget(
              titleText: 'Delete comment ?',
              contentText:
              "Would you like to cotinue deleting this comment ?",
              onPositiveClick: () async {
                await CmtRepository().deleteACmt(comment.commentID);
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
                setState(() {
                  //_totalPost--;
                  _comments.remove(comment);
                });
              },
              onNegativeClick: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            );
          },
          animationType: DialogTransitionType.slideFromLeftFade,
          curve: Curves.fastOutSlowIn,
          duration: Duration(seconds: 1),
        );
      },
        child: Container(
      decoration: BoxDecoration(
        color: i % 2 == 0 ? Colors.white : Colors.greenAccent,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
      child: ListTile(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CustomProfile(customID: comment.userID)));
          },
          child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey,
              backgroundImage: comment.avatar.isEmpty
                  ? AssetImage("assets/default_avatar.jpg")
                  : Image.memory(imagebytes).image),
        ),
        title: Text(
          comment.firstName + " " + comment.lastName,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(comment.content, style: TextStyle(color: Colors.black)),
            SizedBox(height: 6.0),
            RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  text: DateFormat.yMMMMd('en_US')
                      .add_jm()
                      .format(DateTime.parse(comment.dateCmt).toLocal())),
            ),
          ],
        ),
      ),
    ));
  }

  _buildCommentTF() {
    // final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting ? Colors.red : Theme.of(context).disabledColor,
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
                  return 0;
                },
                decoration: InputDecoration.collapsed(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (_isCommenting) {
                    CommentResult cmtRS= await CmtRepository().creteComment(widget._idPost,
                        _commentController.text, UserRepository.getUserID);
                    _commentController.clear();
                    setState(() {
                     _isUpdate=true;
                      _comments.add(Comment(
                          userID: _owner.userID,
                          lastName: _owner.lastName,
                          firstName: _owner.firstName,
                          avatar: _owner.avatar,
                          content: cmtRS.content,
                          dateCmt: DateTime.now().toString(),
                          commentID: cmtRS.commentID));
                      _isCommenting = false;
                    });
                  }
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
          title: FutureBuilder<List<Comment>>(
              future: CmtRepository().getAllComments(widget._idPost),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data.length.toString() + ' Comments',
                    style: TextStyle(color: Colors.white),
                  );
                else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
        body: Container(
          color: Colors.black87,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          Container(
                              child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: _comments.length,
                            itemBuilder: (context, i) {
                              return _buildComment(_comments[i], i);
                            },
                          )),
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
                      ))),
              Divider(height: 1.0),
              _buildCommentTF(),
            ],
          ),
        ));
  }
}
