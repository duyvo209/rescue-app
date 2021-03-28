part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {
  final String userId;

  GetUser(this.userId);
}

class UpdateUser extends UserEvent {
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String imageUser;

  UpdateUser(this.userId, this.name, this.phone, this.address, this.imageUser);
}
