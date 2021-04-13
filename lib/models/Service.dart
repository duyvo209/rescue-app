class Service {
  final String id;
  final String name;
  final String price;
  final String desc;

  Service({this.id, this.name, this.price, this.desc});

  factory Service.fromFireStore(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      desc: json['desc'],
    );
  }

  Service copyWith({
    final String id,
    final String name,
    final String price,
    final String desc,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'desc': desc,
    };
  }
}
