import 'dart:math' show cos, sqrt, asin;

class Store {
  String name;
  String email;
  String phone;
  String address;
  String time;
  double lat;
  double long;
  double m;
  Store(
      {this.name,
      this.email,
      this.phone,
      this.address,
      this.time,
      this.lat,
      this.long,
      this.m});

  factory Store.fromFireStore(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      time: json['time'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  // get  => null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'time': time,
      'lat': lat,
      'long': long,
      'm': m
    };
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
