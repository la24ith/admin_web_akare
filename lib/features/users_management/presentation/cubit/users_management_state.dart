part of 'users_management_cubit.dart';

abstract class UsersManagementState extends Equatable {
  const UsersManagementState();

  @override
  List<Object?> get props => [];
}

class UsersManagementInitial extends UsersManagementState {
  const UsersManagementInitial();
}

class UsersManagementLoading extends UsersManagementState {
  const UsersManagementLoading();
}

class UsersManagementLoaded extends UsersManagementState {
  final List<UserRow> users;
  final UserRoleFilter roleFilter;
  final UserActiveFilter activeFilter;
  final String searchQuery;
  final String? togglingUserId;

  const UsersManagementLoaded({
    required this.users,
    required this.roleFilter,
    required this.activeFilter,
    required this.searchQuery,
    this.togglingUserId,
  });

  UsersManagementLoaded copyWith({
    List<UserRow>? users,
    UserRoleFilter? roleFilter,
    UserActiveFilter? activeFilter,
    String? searchQuery,
    String? togglingUserId,
    bool clearToggling = false,
  }) {
    return UsersManagementLoaded(
      users: users ?? this.users,
      roleFilter: roleFilter ?? this.roleFilter,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      togglingUserId: clearToggling ? null : (togglingUserId ?? this.togglingUserId),
    );
  }

  @override
  List<Object?> get props =>
      [users, roleFilter, activeFilter, searchQuery, togglingUserId];
}

class UsersManagementError extends UsersManagementState {
  final String message;
  const UsersManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
