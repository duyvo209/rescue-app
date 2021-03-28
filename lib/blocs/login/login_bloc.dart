import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rescue/utils/constants.dart';
import 'package:rescue/utils/local_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.empty());
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      try {
        yield state.copyWith(
          loginLoading: true,
          loginError: '',
          loginSuccess: false,
        );
        var result = await firebaseAuth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        if (result != null) {
          await LocalStorage().setUserPass(event.email, event.password);
          await LocalStorage().setLoginMethod(Constants.LOGIN_WITH_EMAIL);
          yield state.copyWith(
              loginLoading: false, loginSuccess: true, user: result.user);
        }
      } on FirebaseAuthException catch (e) {
        yield state.copyWith(
          loginError: e.message,
          loginLoading: false,
          loginSuccess: false,
        );
      }
    }
    if (event is ResetPass) {
      try {
        await firebaseAuth.sendPasswordResetEmail(email: event.email);
      } catch (e) {}
    }
  }
}
