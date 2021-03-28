class UserInfo {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String imageUser;
  final String type;

  UserInfo(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.imageUser,
      this.type});

  factory UserInfo.fromFireStore(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      imageUser: json['image'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': imageUser,
      'type': type
    };
  }
}
