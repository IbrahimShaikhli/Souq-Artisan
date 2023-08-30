import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/config/auth.dart';

// Events
abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;
  final String name; // Add this line

  SignUpButtonPressed(this.name, {required this.email, required this.password});
}

// States
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});
}

// BLoC
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final Authentication _auth = Authentication();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
  }

  void _onSignUpButtonPressed(SignUpButtonPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    try {
      await _auth.signUp(event.email, event.password, event.name);
      emit(SignUpSuccess());
    } catch (error) {
      emit(SignUpFailure(error: 'An error occurred'));
    }
  }
}
