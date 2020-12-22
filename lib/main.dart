
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilogram_app/pages/home_page.dart';
import 'package:kilogram_app/pages/login_page.dart';
import 'package:kilogram_app/pages/splash_page.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'package:kilogram_app/states/authentication_state.dart';
import 'blocs/authentication_bloc.dart';
import 'blocs/login_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'events/authentication_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kilogram',
      home: SplashPage(navigateAfterSecond:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          print(state);
          if (state is AuthenticationFailure) {
            return BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(userRepository: _userRepository),
              child: LoginPage(
                userRepository: _userRepository,
              ),
            );
          }

          if (state is AuthenticationSuccess) {
            return HomePage(
              userRepository: _userRepository,
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(child: Text("Loading")),
            ),
          );
        },
      )),
    );
  }
}
