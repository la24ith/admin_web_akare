import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'حدث خطأ بالخادم، حاول مرة أخرى'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'فشل تسجيل الدخول']) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      [String message = 'هذا الحساب غير مصرح له بالدخول للوحة التحكم'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'حدث خطأ بالتخزين المحلي'])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'تحقق من اتصالك بالإنترنت'])
      : super(message);
}
