part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool loginLoading;
  final bool loginSuccess;
  final String loginError;
  final User user;
  final bool logoutLoading;
  final String logoutError;

  LoginState(
      {this.loginLoading,
      this.loginSuccess,
      this.loginError,
      this.user,
      this.logoutLoading,
      this.logoutError});

  factory LoginState.empty() {
    return LoginState(
        loginLoading: false,
        loginSuccess: false,
        loginError: '',
        user: null,
        logoutError: '',
        logoutLoading: false);
  }
  LoginState copyWith(
      {bool loginLoading,
      bool loginSuccess,
      String loginError,
      User user,
      bool logoutLoading}) {
    return LoginState(
        loginLoading: loginLoading ?? this.loginLoading,
        loginSuccess: loginSuccess ?? this.loginSuccess,
        loginError: loginError ?? this.loginError,
        user: user ?? this.user,
        logoutLoading: logoutLoading ?? this.logoutLoading,
        logoutError: logoutError ?? this.logoutError);
  }

  LoginState copyWithUser(User user) {
    return LoginState(
        loginError: loginError,
        loginLoading: loginLoading,
        loginSuccess: loginSuccess,
        user: user,
        logoutLoading: logoutLoading,
        logoutError: logoutError);
  }

  @override
  List<Object> get props => [
        this.loginLoading,
        this.loginSuccess,
        this.loginError,
        this.user,
        this.logoutLoading,
        this.logoutError
      ];
}
