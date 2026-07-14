import 'package:admin_web/features/property_moderation/domin/repository/property_moderation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/property_moderation_entities.dart';

class GetPropertyReviewDetail
    implements UseCase<PropertyReviewDetail, GetPropertyReviewDetailParams> {
  final PropertyModerationRepository repository;
  GetPropertyReviewDetail(this.repository);

  @override
  Future<Either<Failure, PropertyReviewDetail>> call(
      GetPropertyReviewDetailParams params) {
    return repository.getPropertyReviewDetail(params.propertyId);
  }
}

class GetPropertyReviewDetailParams extends Equatable {
  final String propertyId;
  const GetPropertyReviewDetailParams(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}
