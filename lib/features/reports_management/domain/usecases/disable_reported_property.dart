import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/reports_management_repository.dart';

class DisableReportedProperty
    implements UseCase<void, DisableReportedPropertyParams> {
  final ReportsManagementRepository repository;
  DisableReportedProperty(this.repository);

  @override
  Future<Either<Failure, void>> call(DisableReportedPropertyParams params) {
    return repository.disableReportedProperty(
      reportId: params.reportId,
      propertyId: params.propertyId,
    );
  }
}

class DisableReportedPropertyParams extends Equatable {
  final String reportId;
  final String propertyId;
  const DisableReportedPropertyParams({
    required this.reportId,
    required this.propertyId,
  });

  @override
  List<Object?> get props => [reportId, propertyId];
}
