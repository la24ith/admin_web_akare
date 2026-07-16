import 'package:equatable/equatable.dart';

class UserRow extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role; // user | agent | admin
  final bool isActive;
  final DateTime createdAt;

  const UserRow({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  UserRow copyWith({bool? isActive}) {
    return UserRow(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, fullName, email, phone, role, isActive, createdAt];
}

enum UserRoleFilter { all, user, agent, admin }

extension UserRoleFilterX on UserRoleFilter {
  String? get dbValue => this == UserRoleFilter.all ? null : name;

  String get labelAr {
    switch (this) {
      case UserRoleFilter.all:
        return 'الكل';
      case UserRoleFilter.user:
        return 'مستخدم';
      case UserRoleFilter.agent:
        return 'وكيل';
      case UserRoleFilter.admin:
        return 'أدمن';
    }
  }
}

enum UserActiveFilter { all, active, disabled }

extension UserActiveFilterX on UserActiveFilter {
  bool? get dbValue {
    switch (this) {
      case UserActiveFilter.all:
        return null;
      case UserActiveFilter.active:
        return true;
      case UserActiveFilter.disabled:
        return false;
    }
  }

  String get labelAr {
    switch (this) {
      case UserActiveFilter.all:
        return 'الكل';
      case UserActiveFilter.active:
        return 'نشط';
      case UserActiveFilter.disabled:
        return 'معطّل';
    }
  }
}
