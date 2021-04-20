class Services {
  final String id;
  final String name;
  final String price;
  final String desc;

  Services({this.id, this.name, this.price, this.desc});

  factory Services.fromFireStore(Map<String, dynamic> json) {
    return Services(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      desc: json['desc'],
    );
  }

  Services copyWith({
    final String id,
    final String name,
    final String price,
    final String desc,
  }) {
    return Services(
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
