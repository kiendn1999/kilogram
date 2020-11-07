import 'package:app_cnpm/blocs/register_bloc.dart';
import 'package:app_cnpm/pages/signup_page.dart';
import 'package:app_cnpm/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton1 extends StatelessWidget {
  final UserRepository _userRepository;

  SignUpButton1({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

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
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return BlocProvider<RegisterBloc>(
                  create: (context) => RegisterBloc(userRepository: _userRepository),
                  child: SignUpPage(userRepository: _userRepository)
              );
            }),
          );
        },
      ),
    );
  }
}
