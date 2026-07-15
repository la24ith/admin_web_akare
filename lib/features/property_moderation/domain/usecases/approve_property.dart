import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/property_moderation_repository.dart';

class ApproveProperty implements UseCase<void, ApprovePropertyParams> {
  final PropertyModerationRepository repository;
  ApproveProperty(this.repository);

  @override
  Future<Either<Failure, void>> call(ApprovePropertyParams params) {
    return repository.approveProperty(params.propertyId);
  }
}

class ApprovePropertyParams extends Equatable {
  final String propertyId;
  const ApprovePropertyParams(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}
