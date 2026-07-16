import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/report_row.dart';
import '../../domain/usecases/disable_reported_property.dart';
import '../../domain/usecases/get_reports.dart';
import '../../domain/usecases/mark_reviewed.dart';

part 'reports_management_state.dart';

class ReportsManagementCubit extends Cubit<ReportsManagementState> {
  final GetReports getReports;
  final MarkReviewed markReviewed;
  final DisableReportedProperty disableReportedProperty;

  ReportStatusFilter _filter = ReportStatusFilter.pending;

  ReportsManagementCubit({
    required this.getReports,
    required this.markReviewed,
    required this.disableReportedProperty,
  }) : super(const ReportsManagementInitial());

  Future<void> load() async {
    emit(const ReportsManagementLoading());

    final result = await getReports(GetReportsParams(_filter));

    result.fold(
      (failure) => emit(ReportsManagementError(failure.message)),
      (reports) => emit(ReportsManagementLoaded(reports: reports, filter: _filter)),
    );
  }

  void setFilter(ReportStatusFilter filter) {
    _filter = filter;
    load();
  }

  Future<void> resolveWithoutAction(String reportId) async {
    final current = state;
    if (current is! ReportsManagementLoaded) return;

    emit(current.copyWith(processingReportId: reportId));

    final result = await markReviewed(MarkReviewedParams(reportId));

    result.fold(
      (failure) => emit(ReportsManagementError(failure.message)),
      (_) => load(),
    );
  }

  Future<void> disableProperty({
    required String reportId,
    required String propertyId,
  }) async {
    final current = state;
    if (current is! ReportsManagementLoaded) return;

    emit(current.copyWith(processingReportId: reportId));

    final result = await disableReportedProperty(
      DisableReportedPropertyParams(reportId: reportId, propertyId: propertyId),
    );

    result.fold(
      (failure) => emit(ReportsManagementError(failure.message)),
      (_) => load(),
    );
  }
}
