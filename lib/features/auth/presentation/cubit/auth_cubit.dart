import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_as_admin.dart';
import '../../../../core/session/user_session.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginAsAdmin loginAsAdmin;
  final UserSession userSession;

  AuthCubit({
    required this.loginAsAdmin,
    required this.userSession,
  }) : super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await loginAsAdmin(
      LoginAsAdminParams(email: email.trim(), password: password),
    );

    await result.fold(
      (failure) async => emit(AuthFailureState(failure.message)),
      (_) async {
        // بعد نجاح تسجيل الدخول والتأكد إنه أدمن، حمّل بيانات الجلسة العامة
        await userSession.loadRole();
        emit(const AuthSuccess());
      },
    );
  }
}
