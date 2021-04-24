import 'package:rescue/models/UserInfo.dart';

class Feedback {
  String userId;
  String storeId;
  UserInfo userInfo;
  int rating;
  String comment;

  Feedback({
    this.userId,
    this.storeId,
    this.userInfo,
    this.rating,
    this.comment,
  });

  factory Feedback.fromFireStore(Map<String, dynamic> json) {
    return Feedback(
      userId: json['userId'],
      storeId: json['storeId'],
      userInfo: json['user_info'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'storeId': storeId,
      'user_info': userInfo,
      'rating': rating,
      'comment': comment,
    };
  }
}
