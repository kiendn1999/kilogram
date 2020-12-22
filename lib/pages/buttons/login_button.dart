import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function onPressed;

  const LoginButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ButtonTheme(
      height: 45,
      child: RaisedButton(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.orangeAccent)),
          child: Text(
            "Login to your account",
            style: TextStyle(
                fontSize: 16,
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold),
          ),
          onPressed: this.onPressed),
    );
  }
}
