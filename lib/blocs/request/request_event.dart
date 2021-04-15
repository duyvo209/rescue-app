part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class AddToRequest extends RequestEvent {
  final String userId;
  final String storeId;
  final String requestId;
  final String storeName;
  final Map<String, dynamic> problem;

  final UserInfo userInfo;
  final double lat;
  final double long;
  AddToRequest(
      {this.userId,
      this.storeId,
      this.requestId,
      this.storeName,
      this.problem,
      this.userInfo,
      this.lat,
      this.long});

  Rescue toRescue(UserInfo b) {
    return Rescue.newRescue(
        // idUser: userId,
        // idStore: storeId,
        // storeName: storeName,
        // problem: problem,
        // userInfo: b,
        // lat: lat,
        // long: long,
        );
  }
}

class GetListRequest extends RequestEvent {
  // final String userId;
  final BuildContext context;
  GetListRequest(this.context);
}

class GetRequest extends RequestEvent {
  final String idStore;
  final double lat;
  final double lgn;

  GetRequest({this.idStore, this.lat, this.lgn});
}

class UpdateService extends RequestEvent {
  final List<Service> service;
  final String requestId;
  final String total;

  UpdateService({this.service, this.requestId, this.total});
}
