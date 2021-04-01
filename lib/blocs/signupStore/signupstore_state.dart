part of 'signupstore_bloc.dart';

class SignupstoreState extends Equatable {
  final bool signupLoading;
  final bool signupSuccess;
  final String signupError;

  SignupstoreState({this.signupLoading, this.signupSuccess, this.signupError});

  factory SignupstoreState.empty() {
    return SignupstoreState(
      signupLoading: false,
      signupSuccess: false,
      signupError: '',
    );
  }
  SignupstoreState copyWith({
    bool signupLoading,
    bool signupSuccess,
    String signupError,
  }) {
    return SignupstoreState(
      signupLoading: signupLoading ?? this.signupLoading,
      signupSuccess: signupSuccess ?? this.signupSuccess,
      signupError: signupError ?? this.signupError,
    );
  }

  @override
  List<Object> get props =>
      [this.signupLoading, this.signupSuccess, this.signupError];
}
