part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class Signup extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String uid;

  Signup(
      {@required this.name,
      @required this.email,
      @required this.password,
      this.uid});
}

class SignupStore extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String uid;

  SignupStore({
    @required this.name,
    @required this.email,
    @required this.password,
    this.uid,
  });
}
