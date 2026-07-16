part of 'reports_management_cubit.dart';

abstract class ReportsManagementState extends Equatable {
  const ReportsManagementState();

  @override
  List<Object?> get props => [];
}

class ReportsManagementInitial extends ReportsManagementState {
  const ReportsManagementInitial();
}

class ReportsManagementLoading extends ReportsManagementState {
  const ReportsManagementLoading();
}

class ReportsManagementLoaded extends ReportsManagementState {
  final List<ReportRow> reports;
  final ReportStatusFilter filter;
  final String? processingReportId;

  const ReportsManagementLoaded({
    required this.reports,
    required this.filter,
    this.processingReportId,
  });

  ReportsManagementLoaded copyWith({String? processingReportId}) {
    return ReportsManagementLoaded(
      reports: reports,
      filter: filter,
      processingReportId: processingReportId,
    );
  }

  @override
  List<Object?> get props => [reports, filter, processingReportId];
}

class ReportsManagementError extends ReportsManagementState {
  final String message;
  const ReportsManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
