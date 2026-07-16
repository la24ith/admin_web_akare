import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/report_row.dart';

abstract class ReportsManagementRepository {
  Future<Either<Failure, List<ReportRow>>> getReports({
    required ReportStatusFilter status,
  });

  /// "تمت المراجعة، لا إجراء" — property_reports.status = reviewed فقط
  Future<Either<Failure, void>> markReviewed(String reportId);

  /// "تعطيل العقار" — properties.status = rejected + property_reports.status = reviewed معًا
  Future<Either<Failure, void>> disableReportedProperty({
    required String reportId,
    required String propertyId,
  });
}
