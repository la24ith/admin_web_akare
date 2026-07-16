import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/report_row.dart';
import '../repositories/reports_management_repository.dart';

class GetReports implements UseCase<List<ReportRow>, GetReportsParams> {
  final ReportsManagementRepository repository;
  GetReports(this.repository);

  @override
  Future<Either<Failure, List<ReportRow>>> call(GetReportsParams params) {
    return repository.getReports(status: params.status);
  }
}

class GetReportsParams extends Equatable {
  final ReportStatusFilter status;
  const GetReportsParams(this.status);

  @override
  List<Object?> get props => [status];
}
