import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rescue/models/Order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState.empty());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is NewOrderEvent) {
      try {
        yield state.copyWith(
          orderLoading: true,
          orderSuccess: true,
          orderError: '',
        );

        await FirebaseFirestore.instance
            .collection('order')
            .doc(event.orderId)
            .set({
          "storeId": event.storeId,
          "userId": event.userId,
          "total": event.total,
          "checkout": 1,
        });
        yield state.copyWith(orderLoading: false, orderSuccess: true);
      } catch (e) {
        yield state.copyWith(
          orderLoading: false,
          orderSuccess: false,
          orderError: e.toString(),
        );
      }
    }
  }
}
