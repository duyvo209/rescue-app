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
  Rescue({
    this.idUser,
    this.idStore,
    this.problem,
    this.service,
    this.time,
    this.desc,
    this.lat,
    this.long,
    this.address,
  });

  factory Rescue.fromFireStore(Map<String, dynamic> json) {
    return Rescue(
      idUser: json['idUser'],
      idStore: json['idStore'],
      problem: json['problem'],
      service: json['service'],
      time: json['time'],
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
      'time': DateTime.now(),
      'desc': desc,
      'lat': lat,
      'long': long,
      'address': address,
    };
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
