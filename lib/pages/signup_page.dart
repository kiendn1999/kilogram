
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buttons/signup2_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  bool _showPassword = false;

  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background_app.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 70,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.greenAccent,
                      ),
                      labelText: "Enter your Email",
                      labelStyle: TextStyle(
                          color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  keyboardType: TextInputType.emailAddress,
                  autovalidate: true,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.greenAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color:
                          this._showPassword ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => this._showPassword = !this._showPassword);
                        },
                      ),
                      labelText: "Enter your Password",
                      labelStyle: TextStyle(
                          color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  obscureText: !this._showPassword,
                  autovalidate: true,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.greenAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color:
                          this._showPassword ? Colors.redAccent : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => this._showPassword = !this._showPassword);
                        },
                      ),
                      labelText: "Confirm your Password",
                      labelStyle: TextStyle(
                          color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  obscureText: !this._showPassword,
                  autovalidate: true,
                  autocorrect: false,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: SizedBox(
                  width: double.infinity,
                  child: SignUpButton2(),
                ),
              ),
            ],
          ),
        ));
  }
}