part of 'user_bloc.dart';

class UserState extends Equatable {
  final bool isUserLoading;
  final UserInfo user;
  final String userError;
  final bool userSuccess;

  UserState({this.isUserLoading, this.user, this.userError, this.userSuccess});

  factory UserState.empty() {
    return UserState(
      isUserLoading: false,
      user: null,
      userError: '',
      userSuccess: false,
    );
  }

  UserState copyWith({
    bool isUserLoading,
    UserInfo user,
    String userError,
    bool userSuccess,
  }) {
    return UserState(
      isUserLoading: isUserLoading ?? this.isUserLoading,
      user: user ?? this.user,
      userError: userError ?? this.userError,
      userSuccess: userSuccess ?? this.userSuccess,
    );
  }

  @override
  List<Object> get props => [
        this.isUserLoading,
        this.user,
        this.userError,
        this.userSuccess,
      ];
}
