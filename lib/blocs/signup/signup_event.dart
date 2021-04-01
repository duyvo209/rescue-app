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

// class SignupStore extends SignupEvent {
//   final String name;
//   final String email;
//   final String password;
//   final String address;
//   final String time;
//   final String uid;
//   final double lat;
//   final double long;

//   SignupStore({
//     @required this.name,
//     @required this.email,
//     @required this.password,
//     @required this.address,
//     @required this.time,
//     @required this.lat,
//     @required this.long,
//     this.uid,
//   });
// }
