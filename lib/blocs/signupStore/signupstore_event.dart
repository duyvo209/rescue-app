part of 'signupstore_bloc.dart';

abstract class SignupstoreEvent extends Equatable {
  const SignupstoreEvent();

  @override
  List<Object> get props => [];
}

class SignupStore extends SignupstoreEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String time;
  final String uid;
  final double lat;
  final double long;
  final String status;

  SignupStore({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.phone,
    @required this.address,
    @required this.time,
    @required this.lat,
    @required this.long,
    this.status,
    this.uid,
  });
}
