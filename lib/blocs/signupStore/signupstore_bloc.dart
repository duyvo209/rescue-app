import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signupstore_event.dart';
part 'signupstore_state.dart';

class SignupstoreBloc extends Bloc<SignupstoreEvent, SignupstoreState> {
  SignupstoreBloc() : super(SignupstoreState.empty());
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Stream<SignupstoreState> mapEventToState(
    SignupstoreEvent event,
  ) async* {
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
          await fireStore.collection('store').doc(user.user.uid).set({
            'name': event.name,
            'email': event.email,
            'phone': event.phone,
            'address': event.address,
            // 'time': event.time,
            'lat': event.lat,
            'long': event.long,
            'idStore': user.user.uid,
            'status': 0,
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
