import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kilogram_app/blocs/authentication_bloc.dart';
import 'package:kilogram_app/events/authentication_event.dart';
import 'package:kilogram_app/pages/profile.dart';
import 'package:kilogram_app/pages/search_page.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'createpost_page.dart';

int currentPage = 0;

class HomePage extends StatefulWidget {
  final UserRepository _userRepository;

  const HomePage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeStatePage();
}

class _HomeStatePage extends State<HomePage> {
  var _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Profile(userRepository: widget._userRepository),
      CreatePostPage(userRepository: widget._userRepository),
      SearchPage(),
    ];
  }

  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text("Kilogram"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          ),
        ],
      ),
      body: PageView(
        children: _pages,
        onPageChanged: (i) {
          setState(() {
            currentPage = i;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        currentIndex: currentPage,
        onTap: (i) {
          setState(() {
            currentPage = i;
            _pageController.animateToPage(currentPage,
                duration: Duration(microseconds: 300), curve: Curves.linear);
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Feather.user,
              color: Colors.white,
            ),
            title: Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.upload,
              color: Colors.white,
            ),
            title: Text("Add"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Feather.search,
              color: Colors.white,
            ),
            title: Text("Search"),
          ),
        ],
      ),
    );
  }
}
