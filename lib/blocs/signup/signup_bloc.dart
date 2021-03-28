import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState.empty());
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is Signup) {
      try {
        yield state.copyWith(
          signupLoading: true,
          signupSuccess: false,
          signupError: '',
        );
        // if (event.uid != null) {
        //   await fireStore.collection('users').doc(event.uid).set({
        //     'name': event.name,
        //     'email': event.email,
        //   });
        //   yield state.copyWith(
        //     signupLoading: false,
        //     signupSuccess: true,
        //   );
        //   return;
        // } else {
        var user = await firebaseAuth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        if (user != null) {
          await fireStore.collection('users').doc(user.user.uid).set({
            'name': event.name,
            'email': event.email,
            'type': '1',
          });
          yield state.copyWith(
            signupLoading: false,
            signupSuccess: true,
          );
          // }
        } else {
          yield state.copyWith(signupLoading: false, signupSuccess: false);
        }
      } catch (e) {
        yield state.copyWith(
          signupLoading: false,
          signupSuccess: false,
          signupError: e.toString(),
        );
      }
    }

    if (event is SignupStore) {
      try {
        yield state.copyWith(
          signupLoading: true,
          signupSuccess: false,
          signupError: '',
        );
        var user = await firebaseAuth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        if (user != null) {
          await fireStore.collection('users').doc(user.user.uid).set({
            'name': event.name,
            'email': event.email,
            'type': '0',
          });
          yield state.copyWith(
            signupLoading: false,
            signupSuccess: true,
          );
          // }
        } else {
          yield state.copyWith(signupLoading: false, signupSuccess: false);
        }
      } catch (e) {
        yield state.copyWith(
          signupLoading: false,
          signupSuccess: false,
          signupError: e.toString(),
        );
      }
    }
  }
}
