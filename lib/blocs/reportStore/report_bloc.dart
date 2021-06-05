import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rescue/models/Report.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportState.empty());

  @override
  Stream<ReportState> mapEventToState(
    ReportEvent event,
  ) async* {
    if (event is AddToReport) {
      try {
        yield state.copyWith(
          reportSuccess: false,
          reportLoading: true,
          reportError: '',
        );
        await FirebaseFirestore.instance.collection('report').doc().set({
          'store_id': event.storeId,
          'store_name': event.storeName,
          'report': event.report,
          'time': DateTime.now().toIso8601String(),
        });
        yield state.copyWith(reportLoading: false, reportSuccess: true);
      } catch (e) {
        yield state.copyWith(
          reportLoading: false,
          reportSuccess: false,
          reportError: e.toString(),
        );
      }
    }
  }
}
