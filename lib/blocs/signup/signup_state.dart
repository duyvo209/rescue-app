part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final bool signupLoading;
  final bool signupSuccess;
  final String signupError;

  SignupState({this.signupLoading, this.signupSuccess, this.signupError});

  factory SignupState.empty() {
    return SignupState(
      signupLoading: false,
      signupSuccess: false,
      signupError: '',
    );
  }
  SignupState copyWith({
    bool signupLoading,
    bool signupSuccess,
    String signupError,
  }) {
    return SignupState(
      signupLoading: signupLoading ?? this.signupLoading,
      signupSuccess: signupSuccess ?? this.signupSuccess,
      signupError: signupError ?? this.signupError,
    );
  }

  @override
  List<Object> get props =>
      [this.signupLoading, this.signupSuccess, this.signupError];
}
