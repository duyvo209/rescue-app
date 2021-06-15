import 'dart:math' show cos, sqrt, asin;

import 'package:rescue/models/Service.dart';

class Store {
  String idStore;
  String name;
  String email;
  String phone;
  String address;
  String time;
  double lat;
  double long;
  double m;
  List<Service> listService;
  double avgRating;
  Store({
    this.idStore,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.time,
    this.lat,
    this.long,
    this.m,
    this.listService,
    this.avgRating,
  });

  factory Store.fromFireStore(Map<String, dynamic> json) {
    return Store(
        idStore: json['idStore'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        time: json['time'],
        lat: json['lat'],
        long: json['long'],
        listService: json['list_service']);
  }

  // get  => null;

  Map<String, dynamic> toMap() {
    return {
      'idStore': idStore,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'time': time,
      'lat': lat,
      'long': long,
      'm': m,
      // 'list_service': listService,
    };
  }

  Store copyWith({final List<Service> listService, double avgRating}) {
    return Store(
      listService: listService ?? this.listService,
      idStore: idStore,
      name: name,
      email: email,
      phone: phone,
      address: address,
      time: time,
      lat: lat,
      long: long,
      m: m,
      avgRating: avgRating ?? this.avgRating,
    );
  }

  double getM(lat1, lon1) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((this.lat - lat1) * p) / 2 +
        c(lat1 * p) * c(this.lat * p) * (1 - c((this.long - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
