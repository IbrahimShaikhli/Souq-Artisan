import 'package:bloc/bloc.dart';
import '../../../config/auth.dart';

// Events
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
}

// States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Authentication _auth = Authentication();

  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed); // Register event handler
  }

  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final userCredential = await _auth.login(event.email, event.password);
      if (userCredential != null) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: 'Invalid credentials'));
      }
    } catch (error) {
      emit(LoginFailure(error: 'An error occurred'));
    }
  }
}
