import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rescue/models/UserInfo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState.empty());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetUser) {
      try {
        yield state.copyWith(
          isUserLoading: true,
          userError: '',
          userSuccess: false,
        );
        var result = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .get();
        yield state.copyWith(
            isUserLoading: false,
            userSuccess: true,
            user: UserInfo.fromFireStore(result.data()));
      } catch (e) {
        yield state.copyWith(
          isUserLoading: false,
          userError: e.toString(),
        );
      }
    }

    if (event is UpdateUser) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .update({
          'name': event.name,
          'phone': event.phone,
          'address': event.address,
          'image': event.imageUser,
        });
        add(GetUser(event.userId));
      } catch (e) {
        yield state.copyWith(
          userError: e.toString(),
        );
      }
    }
  }
}
