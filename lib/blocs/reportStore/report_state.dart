part of 'report_bloc.dart';

class ReportState extends Equatable {
  final bool reportLoading;
  final bool reportSuccess;
  final String reportError;
  final Report report;
  final List<Report> listReport;

  ReportState({
    this.reportLoading,
    this.reportSuccess,
    this.reportError,
    this.report,
    this.listReport,
  });

  factory ReportState.empty() {
    return ReportState(
      reportLoading: false,
      reportSuccess: false,
      reportError: '',
      report: null,
      listReport: [],
    );
  }

  ReportState copyWith({
    bool reportLoading,
    bool reportSuccess,
    String reportError,
    Report report,
    List<Report> listFeedback,
  }) {
    return ReportState(
      reportLoading: reportLoading ?? this.reportLoading,
      reportSuccess: reportSuccess ?? this.reportSuccess,
      reportError: reportError ?? this.reportError,
      report: report ?? this.report,
      listReport: listReport ?? this.listReport,
    );
  }

  @override
  List<Object> get props => [
        this.reportLoading,
        this.reportSuccess,
        this.reportError,
        this.report,
        this.listReport,
      ];
}
