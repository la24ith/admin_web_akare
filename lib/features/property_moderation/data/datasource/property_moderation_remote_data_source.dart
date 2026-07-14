import 'package:admin_web/features/property_moderation/data/models/property_moderation_models.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/network/supabase_config.dart';

abstract class PropertyModerationRemoteDataSource {
  Future<List<PropertyQueueItemModel>> getPendingProperties();
  Future<PropertyReviewDetailModel> getPropertyReviewDetail(String propertyId);
  Future<void> approveProperty(String propertyId);
  Future<void> rejectProperty(
      {required String propertyId, required String reason});
}

class PropertyModerationRemoteDataSourceImpl
    implements PropertyModerationRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<List<PropertyQueueItemModel>> getPendingProperties() async {
    final rows = await supabase
        .from('properties')
        .select(
          'id, title, price, created_at, '
          'agents:agent_id(company_name, users:user_id(full_name)), '
          'property_images(image_url, is_primary)',
        )
        .eq('status', 'pending')
        .order('created_at', ascending: true); // الأقدم أولًا (FIFO)

    return (rows as List)
        .map((row) =>
            PropertyQueueItemModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PropertyReviewDetailModel> getPropertyReviewDetail(
      String propertyId) async {
    final row = await supabase
        .from('properties')
        .select(
          'id, title, description, price, listing_type, address_text, '
          'latitude, longitude, rooms_count, bathrooms_count, area_sqm, '
          'status, created_at, '
          'property_types(name_ar), cities(name_ar), '
          'agents:agent_id(id, company_name, license_number, is_verified_agent, '
          'users:user_id(full_name)), '
          'property_images(image_url, sort_order)',
        )
        .eq('id', propertyId)
        .single();

    final agent = row['agents'] as Map<String, dynamic>?;
    final agentId = agent?['id'] as String?;

    int approvedCount = 0;
    int rejectedCount = 0;

    if (agentId != null) {
      final counts = await Future.wait([
        supabase
            .from('properties')
            .select()
            .eq('agent_id', agentId)
            .eq('status', 'active')
            .count(CountOption.exact),
        supabase
            .from('properties')
            .select()
            .eq('agent_id', agentId)
            .eq('status', 'rejected')
            .count(CountOption.exact),
      ]);
      approvedCount = counts[0].count;
      rejectedCount = counts[1].count;
    }

    return PropertyReviewDetailModel.fromSupabase(
      row,
      approvedCount: approvedCount,
      rejectedCount: rejectedCount,
    );
  }

  @override
  Future<void> approveProperty(String propertyId) async {
    // فقط تحديث الحالة — الـ Trigger الموجود بيرسل إشعار الوكيل تلقائيًا
    await supabase
        .from('properties')
        .update({'status': 'active'}).eq('id', propertyId);
  }

  @override
  Future<void> rejectProperty({
    required String propertyId,
    required String reason,
  }) async {
    await supabase.from('properties').update({
      'status': 'rejected',
      'rejection_reason': reason,
    }).eq('id', propertyId);
  }
}
