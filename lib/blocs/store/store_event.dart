part of 'store_bloc.dart';

@immutable
abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class GetListStore extends StoreEvent {
  final double lat;
  final double long;

  GetListStore({this.lat, this.long});
}
