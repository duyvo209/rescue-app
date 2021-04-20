part of 'order_bloc.dart';

class OrderState extends Equatable {
  final bool orderLoading;
  final bool orderSuccess;
  final String orderError;
  final List<Order> order;

  OrderState(
      {this.orderLoading, this.orderSuccess, this.orderError, this.order});

  factory OrderState.empty() {
    return OrderState(
        orderLoading: false, orderSuccess: false, orderError: '', order: []);
  }
  OrderState copyWith({
    bool orderLoading,
    bool orderSuccess,
    String orderError,
    List<Order> order,
  }) {
    return OrderState(
        orderLoading: orderLoading ?? this.orderLoading,
        orderSuccess: orderSuccess ?? this.orderSuccess,
        orderError: orderError ?? this.orderError,
        order: order ?? this.order);
  }

  @override
  List<Object> get props =>
      [this.orderLoading, this.orderSuccess, this.orderError, this.order];

  @override
  String toString() => '$runtimeType $props';
}
