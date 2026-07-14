import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  /// يسجّل الدخول عبر Supabase Auth، ثم يتحقق إنه دور المستخدم = admin.
  /// لو الدور غير admin، بيسجّل خروج المستخدم فورًا ويرجع UnauthorizedFailure.
  Future<Either<Failure, void>> loginAsAdmin({
    required String email,
    required String password,
  });
}
