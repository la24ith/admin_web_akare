import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_row.dart';

abstract class UsersManagementRepository {
  Future<Either<Failure, List<UserRow>>> getUsers({
    String? role,
    bool? isActive,
    String? searchQuery,
  });

  /// تفعيل/تعطيل حساب مستخدم — يشمل المستخدمين والوكلاء والأدمن.
  Future<Either<Failure, void>> setUserActive({
    required String userId,
    required bool isActive,
  });
}
