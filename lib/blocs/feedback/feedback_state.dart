part of 'feedback_bloc.dart';

class FeedbackState extends Equatable {
  final bool feedbackLoading;
  final bool feedbackSuccess;
  final String feedbackError;
  final Feedback feedback;
  final List<Feedback> listFeedback;

  FeedbackState({
    this.feedbackLoading,
    this.feedbackSuccess,
    this.feedbackError,
    this.feedback,
    this.listFeedback,
  });

  factory FeedbackState.empty() {
    return FeedbackState(
      feedbackLoading: false,
      feedbackSuccess: false,
      feedbackError: '',
      feedback: null,
      listFeedback: [],
    );
  }

  FeedbackState copyWith({
    bool feedbackLoading,
    bool feedbackSuccess,
    String feedbackError,
    Feedback feedback,
    List<Feedback> listFeedback,
  }) {
    return FeedbackState(
      feedbackLoading: feedbackLoading ?? this.feedbackLoading,
      feedbackSuccess: feedbackSuccess ?? this.feedbackSuccess,
      feedbackError: feedbackError ?? this.feedbackError,
      feedback: feedback ?? this.feedback,
      listFeedback: listFeedback ?? this.listFeedback,
    );
  }

  @override
  List<Object> get props => [
        this.feedbackLoading,
        this.feedbackSuccess,
        this.feedbackError,
        this.feedback,
        this.listFeedback,
      ];
}
