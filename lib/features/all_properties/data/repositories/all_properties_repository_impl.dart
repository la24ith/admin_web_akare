import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/property_list_row.dart';
import '../../domain/repositories/all_properties_repository.dart';
import '../datasources/all_properties_remote_data_source.dart';

class AllPropertiesRepositoryImpl implements AllPropertiesRepository {
  final AllPropertiesRemoteDataSource remoteDataSource;
  AllPropertiesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PropertyListRow>>> getAllProperties({
    String? status,
    String? searchQuery,
  }) {
    return _guard(() => remoteDataSource.getAllProperties(
          status: status,
          searchQuery: searchQuery,
        ));
  }

  @override
  Future<Either<Failure, void>> disableProperty(String propertyId) {
    return _guard(() => remoteDataSource.disableProperty(propertyId));
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
