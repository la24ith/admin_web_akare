import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_row.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/set_user_active.dart';

part 'users_management_state.dart';

class UsersManagementCubit extends Cubit<UsersManagementState> {
  final GetUsers getUsers;
  final SetUserActive setUserActive;

  UserRoleFilter _roleFilter = UserRoleFilter.all;
  UserActiveFilter _activeFilter = UserActiveFilter.all;
  String _searchQuery = '';
  Timer? _searchDebounce;

  UsersManagementCubit({
    required this.getUsers,
    required this.setUserActive,
  }) : super(const UsersManagementInitial());

  Future<void> load() async {
    emit(const UsersManagementLoading());

    final result = await getUsers(GetUsersParams(
      role: _roleFilter.dbValue,
      isActive: _activeFilter.dbValue,
      searchQuery: _searchQuery.trim().isEmpty ? null : _searchQuery.trim(),
    ));

    result.fold(
      (failure) => emit(UsersManagementError(failure.message)),
      (users) => emit(UsersManagementLoaded(
        users: users,
        roleFilter: _roleFilter,
        activeFilter: _activeFilter,
        searchQuery: _searchQuery,
      )),
    );
  }

  void setRoleFilter(UserRoleFilter filter) {
    _roleFilter = filter;
    load();
  }

  void setActiveFilter(UserActiveFilter filter) {
    _activeFilter = filter;
    load();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), load);
  }

  /// يُستدعى بعد تأكيد المستخدم بـ Dialog (تعطيل يحتاج تأكيد، التفعيل لا)
  Future<void> toggleActive(UserRow user) async {
    final current = state;
    if (current is! UsersManagementLoaded) return;

    emit(current.copyWith(togglingUserId: user.id));

    final result = await setUserActive(
      SetUserActiveParams(userId: user.id, isActive: !user.isActive),
    );

    result.fold(
      (failure) => emit(UsersManagementError(failure.message)),
      (_) => load(),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
