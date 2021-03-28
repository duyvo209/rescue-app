part of 'authencation_bloc.dart';

abstract class AuthencationEvent {}

class StartApp extends AuthencationEvent {}

class LoggedIn extends AuthencationEvent {}

class LoggedOut extends AuthencationEvent {}
