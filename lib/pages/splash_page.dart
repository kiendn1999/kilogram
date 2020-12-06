import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  final Widget navigateAfterSecond;

  SplashPage({this.navigateAfterSecond});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: widget.navigateAfterSecond,
        title: Text(
          'Welcome to Kilogram',
          style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
        image: Image.asset("assets/splash_logo.gif"),
        backgroundColor: Colors.deepPurpleAccent,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 150.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.red);
  }
}
