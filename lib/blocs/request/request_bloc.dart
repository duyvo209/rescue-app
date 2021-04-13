import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/UserInfo.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestState.empty());

  @override
  Stream<RequestState> mapEventToState(
    RequestEvent event,
  ) async* {
    if (event is AddToRequest) {
      try {
        // var query =
        //     await FirebaseFirestore.instance.collection('request').get();

        // var listRequest =
        //     query.docs.map((e) => Rescue().fromFireStore(e.data())).toList();

        // await FirebaseFirestore.instance.collection('request').add({
        //   'rescue': event.rescue.toMap(),
        // });
        //

        Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }

        _locationData = await location.getLocation();
        var lat = _locationData.latitude;
        var lng = _locationData.longitude;
        FirebaseFirestore firebase = FirebaseFirestore.instance;
        var user = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .get();
        UserInfo b = UserInfo.fromFireStore(user.data());
        firebase.collection("request").doc().set({
          'desc': '',
          'idStore': event.storeId,
          'idUser': event.userId,
          'lat_user': lat,
          'lng_user': lng,
          'user_info': b.toMap(),
          'time': DateTime.now().toIso8601String(),
          'store_name': event.storeName,
          'status': 0,
          'lat_store': event.lat,
          'lng_store': event.long,
          'problem': event.problem
        }).then((value) {
          print("success");
        });
      } catch (e) {}
    }

    if (event is GetListRequest) {
      try {
        var user = BlocProvider.of<LoginBloc>(event.context).state.user;
        var data = await FirebaseFirestore.instance
            .collection('request')
            .where('idUser', isEqualTo: user.uid)
            .snapshots()
            .first;
        print(data);

        var listRes = data.docs.map((e) {
          var res = Rescue.fromFireStore(e.data());
          var idRes = e.id;
          res.setRequestId(idRes);
          return res;
        }).toList();
        yield state.copyWith(listRes);
      } catch (e) {
        print(e.toString());
      }
    }

    if (event is GetRequest) {
      var result = await FirebaseFirestore.instance
          .collection('request')
          .where('idStore', isEqualTo: event.idStore)
          .get();
      var listRes = result.docs.map((e) {
        var res = Rescue.fromFireStore(e.data());
        return res;
      }).toList();
      yield state.copyWith(listRes);
    }
  }
}
