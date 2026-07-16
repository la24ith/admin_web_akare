import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_row.dart';
import '../repositories/users_management_repository.dart';

class GetUsers implements UseCase<List<UserRow>, GetUsersParams> {
  final UsersManagementRepository repository;
  GetUsers(this.repository);

  @override
  Future<Either<Failure, List<UserRow>>> call(GetUsersParams params) {
    return repository.getUsers(
      role: params.role,
      isActive: params.isActive,
      searchQuery: params.searchQuery,
    );
  }
}

class GetUsersParams extends Equatable {
  final String? role;
  final bool? isActive;
  final String? searchQuery;
  const GetUsersParams({this.role, this.isActive, this.searchQuery});

  @override
  List<Object?> get props => [role, isActive, searchQuery];
}
