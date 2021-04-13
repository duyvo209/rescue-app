import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rescue/models/Service.dart';
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

    if (event is GetStore) {
      try {
        yield state.copyWith(
          storeLoading: true,
          storeError: '',
          storeSuccess: false,
        );
        var result = await FirebaseFirestore.instance
            .collection('store')
            .doc(event.storeId)
            .get();
        yield state.copyWith(
            storeLoading: false,
            storeSuccess: true,
            store: Store.fromFireStore(result.data()));
      } catch (e) {
        yield state.copyWith(
          storeLoading: false,
          storeError: e.toString(),
        );
      }
    }

    if (event is UpdateStore) {
      try {
        await FirebaseFirestore.instance
            .collection('store')
            .doc(event.storeId)
            .update({
          'name': event.name,
          'phone': event.phone,
          'address': event.address,
          'time': event.time,
        });
        add(GetStore(event.storeId));
      } catch (e) {
        yield state.copyWith(
          storeError: e.toString(),
        );
      }
    }

    if (event is AddToService) {
      try {
        // ignore: unused_local_variable
        var add = await FirebaseFirestore.instance
            .collection('store')
            .doc(event.storeId)
            .collection("service")
            .add({
          'id': event.id,
          'name': event.name,
          'price': event.price,
          'desc': event.desc
        });
      } catch (e) {}
    }

    if (event is GetListService) {
      try {
        var data = await FirebaseFirestore.instance
            .collection('store')
            .doc(event.idStore)
            .collection('service')
            .snapshots()
            .first;
        var listService = data.docs.map((e) {
          var service = Service.fromFireStore(e.data());
          return service;
        }).toList();
        yield state.copyWithService(listService);
      } catch (e) {}
    }

    // if (event is GetListService) {
    //   try {
    //     var getListService = await FirebaseFirestore.instance
    //         .collection('store')
    //         .doc(event.idStore)
    //         .collection('service')
    //         .get();
    //   } catch (e) {}
    // }
  }

  Stream<List<Service>> getListService(String storeId) {
    return fireStore
        .collection('store')
        .doc(storeId)
        .collection('service')
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        return Service.fromFireStore(e.data()).copyWith(id: e.id);
      }).toList();
    });
  }
}
