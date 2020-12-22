import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilogram_app/models/user.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

import 'custom_profile.dart';

class FollowersPage extends StatefulWidget {
  List<String> idFollowers;
  bool isActionFollowers;

  FollowersPage({this.idFollowers, this.isActionFollowers});

  @override
  _FollowersPage createState() => _FollowersPage();
}

class _FollowersPage extends State<FollowersPage> {
  // var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.black87,
          title: Text(
            widget.isActionFollowers
                ? widget.idFollowers.length.toString() + " Followers"
                : widget.idFollowers.length.toString() + " Followings",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            color: Colors.black87,
            child: ListView.builder(
              itemCount: widget.idFollowers.length,
              itemBuilder: ((context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 16.0),
                    child: FutureBuilder<User>(
                      future: UserRepository()
                          .getInfoCusTomUser(widget.idFollowers[index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Uint8List imagebytes =
                              base64Decode(snapshot.data.avatar);
                          return ListTile(
                            title: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CustomProfile(
                                        customID: snapshot.data.userID)));
                              },
                              child: Text(
                                snapshot.data.firstName +
                                    " " +
                                    snapshot.data.lastName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CustomProfile(customID: snapshot.data.userID)));
                              },
                              child: CircleAvatar(
                                backgroundImage: snapshot.data.avatar.isEmpty
                                    ? AssetImage("assets/default_avatar.jpg")
                                    : Image.memory(imagebytes).image,
                                radius: 30.0,
                              ),
                            ),
                          );
                        } else
                          return Center(child: CircularProgressIndicator());
                      },
                    ));
              }),
            )));
  }
}
