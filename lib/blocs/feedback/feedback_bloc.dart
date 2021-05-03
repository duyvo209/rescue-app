import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rescue/models/Feedback.dart';
import 'package:rescue/models/UserInfo.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackState.empty());

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is AddFeedback) {
      try {
        yield state.copyWith(
          feedbackLoading: true,
          feedbackSuccess: false,
          feedbackError: '',
        );
        var user = await FirebaseFirestore.instance
            .collection('users')
            .doc(event.userId)
            .get();
        UserInfo b = UserInfo.fromFireStore(user.data());
        // var query =
        //     await FirebaseFirestore.instance.collection('feedback').get();
        // var listFeedback =
        //     query.docs.map((e) => Feedback.fromFireStore(e.data())).toList();
        // var check =
        //     listFeedback.any((element) => element.userId == event.userId);
        await FirebaseFirestore.instance.collection('feedback').doc().set({
          'userId': event.userId,
          'storeId': event.storeId,
          'user_info': b.toMap(),
          'rating': event.rating,
          'comment': event.comment,
          'time': DateTime.now().toIso8601String(),
        });
        yield state.copyWith(feedbackLoading: false, feedbackSuccess: true);
      } catch (e) {
        yield state.copyWith(
          feedbackLoading: false,
          feedbackSuccess: false,
          feedbackError: e.toString(),
        );
      }
    }

    if (event is GetListFeedback) {
      try {
        yield state.copyWith(
          feedbackLoading: true,
          feedbackSuccess: false,
          feedbackError: '',
        );
        var result = await FirebaseFirestore.instance
            .collection('feedback')
            .snapshots()
            .first;
        var listFeedback = result.docs.map((e) {
          var feedback = Feedback.fromFireStore(e.data());
          return feedback;
        }).toList();
        yield state.copyWith(
            feedbackLoading: false,
            feedbackSuccess: true,
            listFeedback: listFeedback);
        // yield state.copyWith(
        //   feedbackLoading: false,
        //   feedbackSuccess: true,
        //   feedback: Feedback.fromFireStore(result.data()),
        // );
      } catch (e) {
        yield state.copyWith(
          feedbackError: e.toString(),
        );
      }
    }
  }
}
