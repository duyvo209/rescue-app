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

class GetStore extends StoreEvent {
  final String storeId;
  GetStore(this.storeId);
}

class UpdateStore extends StoreEvent {
  final String storeId;
  final String name;
  final String phone;
  final String address;
  final String time;

  UpdateStore(this.storeId, this.name, this.phone, this.address, this.time);
}

class AddToService extends StoreEvent {
  final String storeId;
  final String id;
  final String name;
  final String price;
  final String desc;

  AddToService({this.storeId, this.id, this.name, this.price, this.desc});
}

class GetListService extends StoreEvent {
  final String idStore;

  GetListService(this.idStore);
}
