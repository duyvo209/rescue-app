part of 'authencation_bloc.dart';

class AuthencationState extends Equatable {
  List<Object> get props => [];
}

class AuthencationInitial extends AuthencationState {}

class AuthencationLoading extends AuthencationState {}

class AuthenticationAuthenticated extends AuthencationState {
  final User user;

  AuthenticationAuthenticated({this.user});
  @override
  List<Object> get props => [user];
}

class AuthenticationUnVerifyPhone extends AuthencationState {
  @override
  List<Object> get props => ['AuthenticationUnVerifyPhone'];
}

class AuthenticationUnauthenticated extends AuthencationState {
  @override
  List<Object> get props => ['AuthenticationUnauthenticated'];
}
