import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rescue/models/Store.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState.empty());
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  @override
  Stream<StoreState> mapEventToState(
    StoreEvent event,
  ) async* {
    if (event is GetListStore) {
      try {
        yield state.copyWith(
          storeLoading: true,
          storeError: '',
          storeSuccess: false,
        );
        var result = await FirebaseFirestore.instance.collection('store').get();
        yield state.copyWith(
            storeLoading: false,
            storeSuccess: true,
            listStore: result.docs.map((e) {
              return Store.fromFireStore(e.data());
            }).toList());
      } catch (e) {
        yield state.copyWith(
          storeLoading: false,
          storeError: e.toString(),
        );
      }
    }
  }
}
