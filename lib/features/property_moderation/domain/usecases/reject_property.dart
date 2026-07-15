import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/property_moderation_repository.dart';

class RejectProperty implements UseCase<void, RejectPropertyParams> {
  final PropertyModerationRepository repository;
  RejectProperty(this.repository);

  @override
  Future<Either<Failure, void>> call(RejectPropertyParams params) {
    return repository.rejectProperty(
      propertyId: params.propertyId,
      reason: params.reason,
    );
  }
}

class RejectPropertyParams extends Equatable {
  final String propertyId;
  final String reason;
  const RejectPropertyParams({required this.propertyId, required this.reason});

  @override
  List<Object?> get props => [propertyId, reason];
}
