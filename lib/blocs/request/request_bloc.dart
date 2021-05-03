import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/models/Rescue.dart';
import 'package:rescue/models/Service.dart';
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
          'idRequest': event.requestId,
          'lat_user': lat,
          'lng_user': lng,
          'user_info': b.toMap(),
          'time': DateTime.now().toIso8601String(),
          'store_name': event.storeName,
          'status': 0,
          'checkout': 0,
          'lat_store': event.lat,
          'lng_store': event.long,
          'problems': [event.problem],
          'service': [],
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
        var res = Rescue.fromFireStore(e.data()..addAll({'idRequest': e.id}));
        return res;
      }).toList();
      yield state.copyWith(listRes);
    }

    if (event is UpdateService) {
      // ignore: unused_local_variable
      var data = await FirebaseFirestore.instance
          .collection('request')
          .doc(event.requestId)
          .update({
        'service': event.service.map((e) => e.toMap()).toList(),
        'total': event.total,
      });
    }

    if (event is DeleteService) {
      await FirebaseFirestore.instance
          .collection('request')
          .doc(event.requestId)
          .delete();
    }

    if (event is UpdateCheckout) {
      await FirebaseFirestore.instance
          .collection('request')
          .doc(event.requestId)
          .update({
        'checkout': 1,
      });
    }

    if (event is UpdateStatus) {
      await FirebaseFirestore.instance
          .collection('request')
          .doc(event.requestId)
          .update({
        'status': 1,
      });
    }

    // if (event is CheckOut) {
    //   await FirebaseFirestore.instance
    //       .collection('request')
    //       .doc(event.requestId)
    //       .update({
    //     'total': event.total,
    //     'status': 1,
    //   });
    // }
  }
}
