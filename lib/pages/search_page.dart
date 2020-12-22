import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilogram_app/models/user_search.dart';
import 'package:kilogram_app/pages/custom_profile.dart';
import 'package:kilogram_app/repositories/user_repository.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Future<List<UserSearch>> _users;

  _buildUserTile(UserSearch user) {
    Uint8List imagebytes = base64Decode(
        user.avatar);
    return ListTile(
      leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: user.avatar.length==0
              ? AssetImage('assets/default_avatar.jpg')
              : Image.memory(imagebytes).image),
      title: Text(user.lastName, style: TextStyle(color: Colors.white)),
       onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomProfile(customID: user.userID
                  ),
            ),
          ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: TextField(
            style: TextStyle(color: Colors.white),
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: _clearSearch,
              ),
              filled: true,
            ),
            onChanged: (input) {
              if (input.isNotEmpty) {
                setState(() {
                  _users = UserRepository().searchUser(input);
                });
              }
            },
          ),
        ),
        body: Container(
            color: Colors.black87,
            child: _users == null
                ? Center(
                    child: Text(
                      'Search for a user',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : FutureBuilder<List<UserSearch>>(
                    future: _users,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Colors.green)),
                        );
                      }
                      if (snapshot.data.length == 0)
                        return Center(
                          child: Text('No users found! Please try again.', style: TextStyle(color: Colors.white)),
                        );
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return _buildUserTile(snapshot.data[index]);
                        },
                      );
                    })));
  }
}
