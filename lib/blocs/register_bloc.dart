import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kilogram_app/events/register_event.dart';
import 'package:kilogram_app/repositories/user_repository.dart';
import 'package:kilogram_app/states/register_state.dart';
import 'package:kilogram_app/validators/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          lastName: event.lastName,
          firstName: event.firstName,
          email: event.email,
          password: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(
      String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {String lastName,
      String firstName,
      String email,
      String password}) async* {
    yield RegisterState.loading();
    if (await _userRepository.registerUser(
            lastName, firstName, email, password) ==
        "true") {
      yield RegisterState.success();
    } else {
      yield RegisterState.failure();
    }
  }
}
