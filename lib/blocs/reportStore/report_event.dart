part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class AddToReport extends ReportEvent {
  final String storeId;
  final String storeName;
  final String report;

  AddToReport({this.storeId, this.storeName, this.report});
}
