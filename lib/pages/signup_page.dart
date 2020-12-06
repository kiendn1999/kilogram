import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilogram_app/blocs/authentication_bloc.dart';
import 'package:kilogram_app/blocs/register_bloc.dart';
import 'package:kilogram_app/events/authentication_event.dart';
import 'package:kilogram_app/events/register_event.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'package:kilogram_app/states/register_state.dart';

import 'buttons/signup2_button.dart';

class SignUpPage extends StatefulWidget {
  final UserRepository _userRepository;

  const SignUpPage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPass.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _firstNameController.text.isNotEmpty;

  bool isCorrectConfirm = false;

  bool isButtonEnabled(RegisterState state) {
    return state.isFormValid &&
        isPopulated &&
        !state.isSubmitting &&
        isCorrectConfirm;
  }

  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_app.jpg"),
                    fit: BoxFit.cover)),
            child: BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {
              if (state.isFailure) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Register Failure'),
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
                          Text('Registering...'),
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
                Navigator.pop(context);
              }
            }, child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 70,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: TextFormField(
                            controller: _lastNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.greenAccent,
                                ),
                                labelText: "Last Name",
                                labelStyle: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold)),
                            keyboardType: TextInputType.emailAddress,
                            autovalidate: true,
                            autocorrect: false,
                            validator: (_) {
                              return _lastNameController.text.length < 2
                                  ? 'least 2 characters'
                                  : null;
                            },
                          ),
                        )),
                        Flexible(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: TextFormField(
                            controller: _firstNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.greenAccent,
                                ),
                                labelText: "First Name",
                                labelStyle: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold)),
                            keyboardType: TextInputType.emailAddress,
                            autovalidate: true,
                            autocorrect: false,
                            validator: (_) {
                              return _firstNameController.text.length < 2
                                  ? 'least 2 characters'
                                  : null;
                            },
                          ),
                        )),
                      ],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                      child: TextFormField(
                        controller: _confirmPass,
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
                            labelText: "Confirm your Password",
                            labelStyle: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold)),
                        obscureText: !this._showPassword,
                        autovalidate: true,
                        autocorrect: false,
                        validator: (val) {
                          if (val != _passwordController.text) {
                            isCorrectConfirm = false;
                            return 'Not Match';
                          } else
                            isCorrectConfirm = true;
                          return null;
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
                        child: SignUpButton2(
                          onPressed: () {
                            if (isButtonEnabled(state)) {
                              _onFormSubmitted();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ))));
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
  }

  void _onPasswordChange() {
    _registerBloc
        .add(RegisterPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    FocusScope.of(context).unfocus();
    _registerBloc.add(RegisterSubmitted(
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        email: _emailController.text,
        password: _passwordController.text));
  }
}
