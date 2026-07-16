import '../../../../core/network/supabase_config.dart';
import '../models/user_row_model.dart';

abstract class UsersManagementRemoteDataSource {
  Future<List<UserRowModel>> getUsers({
    String? role,
    bool? isActive,
    String? searchQuery,
  });
  Future<void> setUserActive({required String userId, required bool isActive});
}

class UsersManagementRemoteDataSourceImpl
    implements UsersManagementRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<List<UserRowModel>> getUsers({
    String? role,
    bool? isActive,
    String? searchQuery,
  }) async {
    var query = supabase
        .from('users')
        .select('id, full_name, email, phone, role, is_active, created_at');

    if (role != null) {
      query = query.eq('role', role);
    }
    if (isActive != null) {
      query = query.eq('is_active', isActive);
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim();
      // بحث بالاسم أو البريد أو الهاتف معًا
      query = query.or('full_name.ilike.%$q%,email.ilike.%$q%,phone.ilike.%$q%');
    }

    final rows = await query.order('created_at', ascending: false);

    return (rows as List)
        .map((row) => UserRowModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> setUserActive({
    required String userId,
    required bool isActive,
  }) async {
    await supabase
        .from('users')
        .update({'is_active': isActive}).eq('id', userId);
  }
}
