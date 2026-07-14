import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_config.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart)
  // وليس عبر sl()، لأن SupabaseClient غير مسجّل بـ GetIt.

  @override
  Future<Either<Failure, void>> loginAsAdmin({
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      // 1) تسجيل الدخول عبر Supabase Auth
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        throw const AuthException('فشل تسجيل الدخول');
      }

      // 2) التحقق من الدور بجدول users
      final row = await supabase
          .from('users')
          .select('role, is_active')
          .eq('id', user.id)
          .single();

      final role = row['role'] as String?;
      final isActive = row['is_active'] as bool? ?? true;

      if (role != 'admin' || !isActive) {
        // مو أدمن (أو حسابه معطّل) — سجّل خروجه فورًا وارفض الدخول
        await supabase.auth.signOut();
        throw const UnauthorizedException();
      }
    });
  }

  /// دالة _guard مركزية — نفس نمط بقية الـ Repositories بالمشاريع السابقة،
  /// تلتقط PostgrestException / AuthException وترجع Either<Failure, T>.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on UnauthorizedException {
      return const Left(UnauthorizedFailure());
    } on AuthException catch (e) {
      return Left(AuthFailure(_mapAuthError(e.message)));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _mapAuthError(String raw) {
    if (raw.toLowerCase().contains('invalid login credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    }
    return 'فشل تسجيل الدخول، حاول مرة أخرى';
  }
}

/// استثناء داخلي بسيط لتمييز حالة "دخول ناجح لكن غير مصرح كأدمن"
/// عن أخطاء Supabase الفعلية داخل _guard.
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}
