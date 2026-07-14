import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginAsAdmin implements UseCase<void, LoginAsAdminParams> {
  final AuthRepository repository;
  LoginAsAdmin(this.repository);

  @override
  Future<Either<Failure, void>> call(LoginAsAdminParams params) {
    return repository.loginAsAdmin(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginAsAdminParams extends Equatable {
  final String email;
  final String password;
  const LoginAsAdminParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
