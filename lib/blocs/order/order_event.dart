part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {}

class NewOrderEvent extends OrderEvent {
  final String userId;
  final String storeId;
  final String orderId;
  final String total;
  final int checkout;

  NewOrderEvent({
    this.userId,
    this.storeId,
    this.orderId,
    this.total,
    this.checkout,
  });

  @override
  List<Object> get props => [];

  // String toString() => '$runtimeType $props';

  Order toOrder() {
    return Order.newOrder();
  }
}
