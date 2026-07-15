import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/property_moderation_entities.dart';
import '../../domain/repositories/property_moderation_repository.dart';
import '../datasources/property_moderation_remote_data_source.dart';

class PropertyModerationRepositoryImpl implements PropertyModerationRepository {
  final PropertyModerationRemoteDataSource remoteDataSource;
  PropertyModerationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PropertyQueueItem>>> getPendingProperties() {
    return _guard(() => remoteDataSource.getPendingProperties());
  }

  @override
  Future<Either<Failure, PropertyReviewDetail>> getPropertyReviewDetail(
      String propertyId) {
    return _guard(() => remoteDataSource.getPropertyReviewDetail(propertyId));
  }

  @override
  Future<Either<Failure, void>> approveProperty(String propertyId) {
    return _guard(() => remoteDataSource.approveProperty(propertyId));
  }

  @override
  Future<Either<Failure, void>> rejectProperty({
    required String propertyId,
    required String reason,
  }) {
    return _guard(() => remoteDataSource.rejectProperty(
          propertyId: propertyId,
          reason: reason,
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
