part of 'request_bloc.dart';

class RequestState extends Equatable {
  final List<Request> request;
  RequestState({this.request});

  factory RequestState.empty() {
    return RequestState(request: []);
  }

  RequestState copyWith(List<Request> request) {
    return RequestState(request: request ?? this.request);
  }

  @override
  List<Object> get props => [this.request];
}

class RequestInitial extends RequestState {}
