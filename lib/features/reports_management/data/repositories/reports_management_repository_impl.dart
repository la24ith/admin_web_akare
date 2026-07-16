import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/report_row.dart';
import '../../domain/repositories/reports_management_repository.dart';
import '../datasources/reports_management_remote_data_source.dart';

class ReportsManagementRepositoryImpl implements ReportsManagementRepository {
  final ReportsManagementRemoteDataSource remoteDataSource;
  ReportsManagementRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ReportRow>>> getReports({
    required ReportStatusFilter status,
  }) {
    return _guard(() => remoteDataSource.getReports(status: status.dbValue));
  }

  @override
  Future<Either<Failure, void>> markReviewed(String reportId) {
    return _guard(() => remoteDataSource.markReviewed(reportId));
  }

  @override
  Future<Either<Failure, void>> disableReportedProperty({
    required String reportId,
    required String propertyId,
  }) {
    return _guard(() => remoteDataSource.disableReportedProperty(
          reportId: reportId,
          propertyId: propertyId,
        ));
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
