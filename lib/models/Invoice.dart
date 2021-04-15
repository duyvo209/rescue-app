import 'package:rescue/models/Service.dart';
import 'package:rescue/models/UserInfo.dart';

class Invoice {
  String invoiceId;
  String userId;
  String storeId;
  String total;
  UserInfo userInfo;
  Service problem;
  DateTime time;
  int status;
  int checkout;
  static const status_new = 0;
  static const checkout_new = 0;

  Invoice.newInvoice({
    this.invoiceId,
    this.userId,
    this.storeId,
    this.total,
    this.userInfo,
    this.problem,
  })  : time = DateTime.now(),
        status = status_new,
        checkout = checkout_new;

  Invoice({
    this.invoiceId,
    this.userId,
    this.storeId,
    this.total,
    this.userInfo,
    this.problem,
    this.status,
    this.checkout,
    this.time,
  });

  factory Invoice.fromFireStore(Map<String, dynamic> json) {
    return Invoice(
        invoiceId: json['invoiceId'],
        userId: json['userId'],
        storeId: json['storeId'],
        total: json['total'],
        userInfo: UserInfo.fromFireStore(json['user_info']),
        problem: Service.fromFireStore(json['problem']),
        status: json['status'],
        checkout: json['checkout'],
        time: DateTime.parse(json['time']));
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'userId': userId,
      'storeId': storeId,
      'total': total,
      'user_info': userInfo?.toMap(),
      'problem': problem.toMap(),
      'status': status,
      'checkout': checkout,
      'time': time,
    };
  }

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [
        this.invoiceId,
        this.userId,
        this.storeId,
        this.total,
        this.userInfo,
        this.problem,
        this.status,
        this.checkout,
        this.time,
      ];
}
