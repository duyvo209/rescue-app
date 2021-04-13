import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/blocs/store/store_bloc.dart';
import 'package:rescue/blocs/user/user_bloc.dart';
import 'package:rescue/utils/constants.dart';
import 'package:rescue/utils/local_storage.dart';

part 'authencation_event.dart';
part 'authencation_state.dart';

class AuthencationBloc extends Bloc<AuthencationEvent, AuthencationState> {
  final UserBloc userBloc;
  final StoreBloc storeBloc;
  final LoginBloc loginBloc;

  AuthencationBloc(
      {@required this.userBloc,
      @required this.storeBloc,
      @required this.loginBloc})
      : super(AuthencationInitial());
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<AuthencationState> mapEventToState(
    AuthencationEvent event,
  ) async* {
    if (event is StartApp) {
      try {
        yield AuthencationLoading();
        var userInfo = await LocalStorage().getUserPass();
        var storeInfo = await LocalStorage().getUserPass();
        String user = userInfo['user'];
        String pass = userInfo['pass'];
        String userS = storeInfo['user'];
        String passS = storeInfo['pass'];
        String loginMethod = await LocalStorage().getLoginMethod();
        if (loginMethod == Constants.LOGIN_WITH_EMAIL) {
          UserCredential userCredential =
              await firebaseAuth.signInWithEmailAndPassword(
            email: user,
            password: pass,
          );
          userBloc.add(GetUser(userCredential.user.uid));
          yield AuthenticationAuthenticated(user: userCredential.user);
        }
        if (loginMethod == Constants.LOGIN_WITH_STORE) {
          UserCredential userCredential = await firebaseAuth
              .signInWithEmailAndPassword(email: userS, password: passS);
          storeBloc.add(GetStore(userCredential.user.uid));
          yield AuthenticationAuthenticated(user: userCredential.user);
        }
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }
    if (event is LoggedIn) {
      add(StartApp());
    }
    if (event is LoggedOut) {
      try {
        yield AuthencationLoading();
        await LocalStorage().deleteUserData();
        yield AuthenticationUnauthenticated();
      } catch (e) {
        yield AuthenticationUnauthenticated();
      }
    }
  }
}
