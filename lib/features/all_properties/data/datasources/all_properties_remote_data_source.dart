import '../../../../core/network/supabase_config.dart';
import '../models/property_list_row_model.dart';

abstract class AllPropertiesRemoteDataSource {
  Future<List<PropertyListRowModel>> getAllProperties({
    String? status,
    String? searchQuery,
  });
  Future<void> disableProperty(String propertyId);
}

class AllPropertiesRemoteDataSourceImpl implements AllPropertiesRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<List<PropertyListRowModel>> getAllProperties({
    String? status,
    String? searchQuery,
  }) async {
    var query = supabase.from('properties').select(
          'id, title, price, status, created_at, '
          'agents:agent_id(company_name, users:user_id(full_name)), '
          'cities(name_ar), '
          'property_images(image_url, is_primary)',
        );

    if (status != null) {
      query = query.eq('status', status);
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query = query.ilike('title', '%${searchQuery.trim()}%');
    }

    final rows = await query.order('created_at', ascending: false);

    return (rows as List)
        .map((row) => PropertyListRowModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> disableProperty(String propertyId) async {
    await supabase.from('properties').update({
      'status': 'rejected',
      'rejection_reason': 'أُزيل من قبل الإدارة',
    }).eq('id', propertyId);
  }
}
