import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

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
        firebase.collection("res").doc("123").set({"123": "123"});
        // var add = await FirebaseFirestore.instance
        //     .collection('request')
        //     .doc(event.userId)
        //     .set({
        //   "idstore": "",
        //   'userId': event.userId,
        //   "time": "",
        //   "problem": ""
        // });
        firebase.collection("request").doc(event.userId).set({
          "storeName": event.storeName,
          'userId': event.userId,
          "time": DateTime.now(),
          'problem': event.problem,
          "status": "0",
        }).then((value) {
          print("success");
        });
      } catch (e) {}
    }
  }
}
