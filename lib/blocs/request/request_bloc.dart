import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue/blocs/login/login_bloc.dart';
import 'package:rescue/models/Rescue.dart';

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
        FirebaseFirestore firebase = FirebaseFirestore.instance;
        firebase
            .collection("request")
            .doc()
            .set(event.toRescue().toMap())
            .then((value) {
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
  }
}
