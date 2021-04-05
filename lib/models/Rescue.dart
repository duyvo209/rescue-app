import 'package:cloud_firestore/cloud_firestore.dart';

class Rescue {
  String idUser;
  String idStore;
  String problem;
  List<String> service = [];
  DateTime time;
  String desc;
  double lat;
  double long;
  String address;
  String idRequest;
  static const status_new = 0;
  int status;

  Rescue.newRescue(
      {this.idUser,
      this.idStore,
      this.idRequest,
      this.problem,
      this.address,
      this.desc,
      this.service})
      : status = status_new,
        time = DateTime.now();

  Rescue(
      {this.idUser,
      this.idStore,
      this.problem,
      this.service,
      this.time,
      this.status,
      this.desc,
      this.lat,
      this.long,
      this.address,
      this.idRequest});

  factory Rescue.fromFireStore(Map<String, dynamic> json) {
    return Rescue(
      idUser: json['idUser'],
      idStore: json['idStore'],
      problem: json['problem'],
      service: json['service'],
      time: (json['time'] as Timestamp).toDate(),
      status: json['status'],
      desc: json['json'],
      lat: json['lat'],
      long: json['long'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'idStore': idStore,
      'problem': problem,
      'service': service,
      'time': time,
      'status': status,
      'desc': desc,
      'lat': lat,
      'long': long,
      'address': address,
    };
  }

  void setRequestId(String id) {
    this.idRequest = id;
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [
        this.idUser,
        this.idStore,
        this.service,
        this.problem,
        this.time,
        this.lat,
        this.long,
        this.address,
        this.desc,
      ];
}
