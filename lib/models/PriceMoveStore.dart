class PriceMoveStore {
  String id;
  double from;
  double to;
  String price;

  PriceMoveStore({this.id, this.from, this.to, this.price});

  factory PriceMoveStore.fromFireStore(Map<String, dynamic> json) {
    return PriceMoveStore(
      price: json['price'],
      from: json['from'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'from': from,
      'to': to,
    };
  }
}
