
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilogram_app/blocs/authentication_bloc.dart';
import 'package:kilogram_app/blocs/login_bloc.dart';
import 'package:kilogram_app/events/authentication_event.dart';
import 'package:kilogram_app/events/login_event.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'package:kilogram_app/states/login_state.dart';

import 'buttons/login_button.dart';
import 'buttons/signup1_button.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginPage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    //
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_app.jpg"),
                    fit: BoxFit.cover)),
            child: BlocListener<LoginBloc, LoginState>(listener:
                (context, state) async{
              if (state.isFailure) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(await widget._userRepository.checkLoginCredentials(_emailController.text, _passwordController.text)),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Color(0xffffae88),
                    ),
                  );
              }

              if (state.isSubmitting) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Logging In...'),
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        ],
                      ),
                      backgroundColor: Color(0xffffae88),
                    ),
                  );
              }

              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedIn(),
                );
              }
            }, child:
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 70,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.greenAccent,
                          ),
                          labelText: "Enter your Email",
                          labelStyle: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold)),
                      keyboardType: TextInputType.emailAddress,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isEmailValid ? 'Invalid Email' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.greenAccent,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: this._showPassword
                                  ? Colors.redAccent
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() =>
                                  this._showPassword = !this._showPassword);
                            },
                          ),
                          labelText: "Enter your Password",
                          labelStyle: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold)),
                      obscureText: !this._showPassword,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: SizedBox(
                      width: double.infinity,
                      child: LoginButton(
                        onPressed: () {
                          if (isButtonEnabled(state)) _onFormSubmitted();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: SizedBox(
                      width: double.infinity,
                      child:
                          SignUpButton1(userRepository: widget._userRepository),
                    ),
                  ),
                ],
              );
            }))));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    FocusScope.of(context).unfocus();
    _passwordController.addListener(_onPasswordChange);
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
