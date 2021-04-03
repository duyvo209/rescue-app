part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class AddToRequest extends RequestEvent {
  final String userId;
  final String storeName;
  final String problem;
  AddToRequest({this.userId, this.storeName, this.problem});
}
