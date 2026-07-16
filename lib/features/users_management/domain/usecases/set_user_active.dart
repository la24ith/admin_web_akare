import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/users_management_repository.dart';

class SetUserActive implements UseCase<void, SetUserActiveParams> {
  final UsersManagementRepository repository;
  SetUserActive(this.repository);

  @override
  Future<Either<Failure, void>> call(SetUserActiveParams params) {
    return repository.setUserActive(
      userId: params.userId,
      isActive: params.isActive,
    );
  }
}

class SetUserActiveParams extends Equatable {
  final String userId;
  final bool isActive;
  const SetUserActiveParams({required this.userId, required this.isActive});

  @override
  List<Object?> get props => [userId, isActive];
}
