import 'package:admin_web/features/property_moderation/data/datasource/property_moderation_remote_data_source.dart';
import 'package:admin_web/features/property_moderation/domin/entities/property_moderation_entities.dart';
import 'package:admin_web/features/property_moderation/domin/repository/property_moderation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';

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
