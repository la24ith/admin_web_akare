import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_row.dart';
import '../../domain/repositories/users_management_repository.dart';
import '../datasources/users_management_remote_data_source.dart';

class UsersManagementRepositoryImpl implements UsersManagementRepository {
  final UsersManagementRemoteDataSource remoteDataSource;
  UsersManagementRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<UserRow>>> getUsers({
    String? role,
    bool? isActive,
    String? searchQuery,
  }) {
    return _guard(() => remoteDataSource.getUsers(
          role: role,
          isActive: isActive,
          searchQuery: searchQuery,
        ));
  }

  @override
  Future<Either<Failure, void>> setUserActive({
    required String userId,
    required bool isActive,
  }) {
    return _guard(() => remoteDataSource.setUserActive(
          userId: userId,
          isActive: isActive,
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
