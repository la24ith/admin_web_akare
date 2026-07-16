import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/reports_management_repository.dart';

class MarkReviewed implements UseCase<void, MarkReviewedParams> {
  final ReportsManagementRepository repository;
  MarkReviewed(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkReviewedParams params) {
    return repository.markReviewed(params.reportId);
  }
}

class MarkReviewedParams extends Equatable {
  final String reportId;
  const MarkReviewedParams(this.reportId);

  @override
  List<Object?> get props => [reportId];
}
