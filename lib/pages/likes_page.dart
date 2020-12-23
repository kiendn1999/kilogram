import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilogram_app/models/like.dart';

import 'custom_profile.dart';

class LikePage extends StatefulWidget {
  List<LikeUser> _likeUsers;

  LikePage(this._likeUsers);

  @override
  _LikePage createState() => _LikePage();
}

class _LikePage extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.black87,
          title: Text(
            widget._likeUsers.length.toString() + ' Likes',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            color: Colors.black87,
            child: ListView.builder(
              itemCount: widget._likeUsers.length,
              itemBuilder: ((context, index) {
                Uint8List imagebytes =
                    base64Decode(widget._likeUsers[index].avatar);
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 16.0),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomProfile(
                                customID: widget._likeUsers[index].userID)));
                      },
                      child: Text(
                        widget._likeUsers[index].firstName +
                            " " +
                            widget._likeUsers[index].lastName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomProfile(
                                customID: widget._likeUsers[index].userID)));
                      },
                      child: CircleAvatar(
                        backgroundImage: widget._likeUsers[index].avatar.isEmpty
                            ? AssetImage("assets/default_avatar.jpg")
                            : Image.memory(imagebytes).image,
                        radius: 30.0,
                      ),
                    ),
                  ),
                );
              }),
            )));
  }
}
