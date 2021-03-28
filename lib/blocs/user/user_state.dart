part of 'user_bloc.dart';

class UserState extends Equatable {
  final bool isUserLoading;
  final UserInfo user;
  final String userError;

  UserState({this.isUserLoading, this.user, this.userError});

  factory UserState.empty() {
    return UserState(
      isUserLoading: false,
      user: null,
      userError: '',
    );
  }

  UserState copyWith({
    bool isUserLoading,
    UserInfo user,
    String userError,
  }) {
    return UserState(
      isUserLoading: isUserLoading ?? this.isUserLoading,
      user: user ?? this.user,
      userError: userError ?? this.userError,
    );
  }

  @override
  List<Object> get props => [
        this.isUserLoading,
        this.user,
        this.userError,
      ];
}
