import 'package:app_cnpm/blocs/authentication_bloc.dart';
import 'package:app_cnpm/events/authentication_event.dart';
import 'package:app_cnpm/models/posts_data.dart';
import 'package:app_cnpm/pages/activity_page.dart';
import 'package:app_cnpm/pages/createpost_page.dart';
import 'package:app_cnpm/pages/custom_profile.dart';
import 'package:app_cnpm/pages/feed_page.dart';
import 'package:app_cnpm/pages/profile.dart';
import 'package:app_cnpm/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

int currentPage = 0;
class HomePage extends StatefulWidget {

  final User user;

  const HomePage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeStatePage();

}

class _HomeStatePage extends State<HomePage>{

  var _pages = [
    Feed(),
    SearchPage(),
    CreatePostPage(),
    ActivityPage(),
    Profile(ipost: posts[2],),
  ];
  var _pageController = PageController();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text("Kilogram"),
          // leading: IconButton(
          //     icon: Icon(Feather.camera, color: Colors.white,)
          // ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLoggedOut());
              },
            ),
          ],
        ),
      body: PageView(
        children: _pages,
        onPageChanged: (i){
          setState(() {
            currentPage = i;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        currentIndex: currentPage,
        onTap: (i){
          setState(() {
            currentPage = i;
            _pageController.animateToPage(currentPage, duration: Duration(microseconds: 300), curve: Curves.linear);
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Foundation.home,color: Colors.white),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.search, color: Colors.white,),
            title: Text("Search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.upload, color: Colors.white,),
            title: Text("Add"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.bell, color: Colors.white,),
            title: Text("Notification"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.user,color: Colors.white,),
            title: Text("Account"),
          ),
        ],


      ),

    );
  }
}