import 'package:rescue/models/UserInfo.dart';

class Feedback {
  String userId;
  String storeId;
  UserInfo userInfo;
  String storeName;
  int rating;
  String comment;

  Feedback({
    this.userId,
    this.storeId,
    this.userInfo,
    this.storeName,
    this.rating,
    this.comment,
  });

  factory Feedback.fromFireStore(Map<String, dynamic> json) {
    return Feedback(
      userId: json['userId'],
      storeId: json['storeId'],
      userInfo: json['user_info'],
      storeName: json['store_name'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storeId': storeId,
      'user_info': userInfo,
      'store_name': storeName,
      'rating': rating,
      'comment': comment,
    };
  }
}
