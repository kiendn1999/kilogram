
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kilogram_app/models/posts_data.dart';
import 'package:kilogram_app/pages/custom_profile.dart';
import 'package:kilogram_app/pages/profile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  //Future<QuerySnapshot> _users;
  final _users=null;

  _buildUserTile(Post ipost) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20.0,
          backgroundImage: NetworkImage(ipost.userImage)
      ),
      title: Text(ipost.username),
      onTap: () =>
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomProfile(ipost: ipost,
                  ),
            ),
          ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      //_users = null;
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
          onSubmitted: (input) {
            if (input.isNotEmpty) {
              setState(() {
                //_users = DatabaseService.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: Container(color: Colors.black87,child: _users == null
          ? Center(
        child: Text('Search for a user', style: TextStyle(color: Colors.white),),
      )
          : FutureBuilder(
        future: _users,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text('No users found! Please try again.'),
            );
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _buildUserTile(posts[index]);
            },
          );
        },
      ),)
    );
  }
}