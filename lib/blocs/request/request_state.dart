part of 'request_bloc.dart';

// ignore: must_be_immutable
class RequestState extends Equatable {
  final List<Rescue> request;
  List<Rescue> listRescue = [];
  RequestState({this.request, this.listRescue});

  factory RequestState.empty() {
    return RequestState(request: [], listRescue: []);
  }

  RequestState copyWith(List<Rescue> request) {
    return RequestState(
      request: request ?? this.request,
      listRescue: listRescue ?? this.listRescue,
    );
  }

  @override
  List<Object> get props => [this.request, this.listRescue];
}
