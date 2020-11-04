import 'package:app_cnpm/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ButtonTheme(
      height: 45,
      child: RaisedButton(
        color: Colors.black12,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.orangeAccent)),
        child: Text(
          "Sign up",
          style: TextStyle(
              fontSize: 16,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignUpPage()));
        },
      ),
    );
  }
}
