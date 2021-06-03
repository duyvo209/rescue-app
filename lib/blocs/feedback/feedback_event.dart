part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class AddFeedback extends FeedbackEvent {
  final String userId;
  final String storeId;
  final UserInfo userInfo;
  final String storeName;
  final int rating;
  final String comment;

  AddFeedback({
    this.userId,
    this.storeId,
    this.storeName,
    this.userInfo,
    this.rating,
    this.comment,
  });
}

class GetListFeedback extends FeedbackEvent {
  final String storeId;

  GetListFeedback({this.storeId});
}

class UpdateReport extends FeedbackEvent {
  final String feedbackId;
  final String report;

  UpdateReport({this.feedbackId, this.report});
}
