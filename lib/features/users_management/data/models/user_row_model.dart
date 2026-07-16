import '../../domain/entities/user_row.dart';

class UserRowModel extends UserRow {
  const UserRowModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
    required super.isActive,
    required super.createdAt,
  });

  /// يتوقّع صف من:
  /// users.select('id, full_name, email, phone, role, is_active, created_at')
  factory UserRowModel.fromSupabase(Map<String, dynamic> row) {
    return UserRowModel(
      id: row['id'] as String,
      fullName: row['full_name'] as String? ?? '',
      email: row['email'] as String? ?? '',
      phone: row['phone'] as String? ?? '',
      role: row['role'] as String? ?? 'user',
      isActive: row['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
