import 'package:rescue/models/Services.dart';
import 'package:rescue/models/UserInfo.dart';

class Order {
  String orderId;
  String userId;
  String storeId;
  String total;
  UserInfo userInfo;
  Services services;
  DateTime time;
  int status;
  int checkout;
  static const status_new = 0;
  static const checkout_new = 0;

  Order.newOrder({
    this.storeId,
    this.userId,
    this.total,
    this.userInfo,
    this.services,
  })  : time = DateTime.now(),
        status = status_new,
        checkout = checkout_new;

  Order({
    this.orderId,
    this.userId,
    this.storeId,
    this.total,
    this.userInfo,
    this.services,
    this.status,
    this.checkout,
    this.time,
  });

  factory Order.fromFireStore(Map<String, dynamic> json) {
    return Order(
        orderId: json['orderId'],
        userId: json['userId'],
        storeId: json['storeId'],
        total: json['total'],
        userInfo: UserInfo.fromFireStore(json['user_info']),
        services: Services.fromFireStore(json['problem']),
        status: json['status'],
        checkout: json['checkout'],
        time: DateTime.parse(json['time']));
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'storeId': storeId,
      'total': total,
      'user_info': userInfo?.toMap(),
      'services': services.toMap(),
      'status': status,
      'checkout': checkout,
      'time': time,
    };
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [
        this.orderId,
        this.userId,
        this.storeId,
        this.total,
        this.userInfo,
        this.services,
        this.status,
        this.checkout,
        this.time,
      ];
}
