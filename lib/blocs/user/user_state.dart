part of 'user_bloc.dart';

// ignore: must_be_immutable
class UserState extends Equatable {
  final bool isUserLoading;
  final UserInfo user;
  final String userError;
  final bool userSuccess;
  List<UserInfo> listUser = [];

  UserState({
    this.isUserLoading,
    this.user,
    this.userError,
    this.userSuccess,
    this.listUser,
  });

  factory UserState.empty() {
    return UserState(
      isUserLoading: false,
      user: null,
      userError: '',
      userSuccess: false,
      listUser: [],
    );
  }

  UserState copyWith({
    bool isUserLoading,
    UserInfo user,
    String userError,
    bool userSuccess,
    List<UserInfo> listUser,
  }) {
    return UserState(
      isUserLoading: isUserLoading ?? this.isUserLoading,
      user: user ?? this.user,
      userError: userError ?? this.userError,
      userSuccess: userSuccess ?? this.userSuccess,
      listUser: listUser ?? this.listUser,
    );
  }

  @override
  List<Object> get props => [
        this.isUserLoading,
        this.user,
        this.userError,
        this.userSuccess,
        this.listUser,
      ];
}
