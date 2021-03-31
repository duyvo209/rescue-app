class Store {
  String name;
  String email;
  String address;
  String time;
  double lat;
  double long;

  Store({
    this.name,
    this.email,
    this.address,
    this.time,
    this.lat,
    this.long,
  });

  factory Store.fromFireStore(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      time: json['time'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'time': time,
      'lat': lat,
      'long': long,
    };
  }
}
