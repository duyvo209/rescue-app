import 'package:rescue/models/Service.dart';
import 'package:rescue/models/Services.dart';
import 'package:rescue/models/UserInfo.dart';
import 'dart:math' show cos, sqrt, asin;

class Rescue {
  String idUser;
  String idStore;
  String storeName;
  List<Service> problems;
  List<Services> service = [];
  DateTime time;
  String desc;
  double lat;
  double long;
  double latUser;
  double lngUser;
  double m;
  String address;
  String idRequest;
  static const status_new = 0;
  static const checkout_new = 0;
  int status;
  int checkout;
  UserInfo userInfo;

  Rescue.newRescue(
      {this.idUser,
      this.idStore,
      this.storeName,
      this.idRequest,
      this.problems,
      this.address,
      this.desc,
      this.lat,
      this.long,
      this.latUser,
      this.lngUser,
      this.m,
      this.service,
      this.userInfo})
      : status = status_new,
        checkout = checkout_new,
        time = DateTime.now();

  Rescue(
      {this.idUser,
      this.idStore,
      this.storeName,
      this.problems,
      this.service,
      this.time,
      this.status,
      this.checkout,
      this.desc,
      this.lat,
      this.long,
      this.latUser,
      this.lngUser,
      this.m,
      this.address,
      this.idRequest,
      this.userInfo});

  factory Rescue.fromFireStore(Map<String, dynamic> json) {
    return Rescue(
        idUser: json['idUser'],
        idStore: json['idStore'],
        idRequest: json['idRequest'],
        storeName: json['store_name'],
        problems: (json['problems'] as List)
            .map((e) => Service.fromFireStore(e))
            .toList(),
        service: (json['service'] as List)
            .map((e) => Services.fromFireStore(e))
            .toList(),
        time: DateTime.parse(json['time']),
        status: json['status'],
        checkout: json['checkout'],
        desc: json['json'],
        lat: json['lat'],
        long: json['long'],
        latUser: json['lat_user'],
        lngUser: json['lng_user'],
        m: json['m'],
        address: json['address'],
        userInfo: UserInfo.fromFireStore(json['user_info']));
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'idStore': idStore,
      'idRequest': idRequest,
      'store_name': storeName,
      'problems': problems.map((e) => e.toMap()).toList(),
      'service': service,
      'time': time,
      'status': status,
      'checkout': checkout,
      'desc': desc,
      'lat': lat,
      'long': long,
      'lat_user': latUser,
      'lng_user': lngUser,
      'm': m,
      'address': address,
      'user_info': userInfo?.toMap()
    };
  }

  void setRequestId(String id) {
    this.idRequest = id;
  }

  double getM(lat1, lon1) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((this.latUser - lat1) * p) / 2 +
        c(lat1 * p) *
            c(this.latUser * p) *
            (1 - c((this.lngUser - lon1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [
        this.idUser,
        this.idStore,
        this.idRequest,
        this.storeName,
        this.service,
        this.problems,
        this.time,
        this.lat,
        this.long,
        this.latUser,
        this.lngUser,
        this.address,
        this.desc,
      ];
}
