import 'package:postgrest/postgrest.dart';
import '../../../../core/network/supabase_config.dart';
import '../models/dashboard_models.dart';

abstract class AdminDashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats();
  Future<List<PendingPropertyPreviewModel>> getRecentPendingProperties({int limit = 5});
  Future<List<PendingReportPreviewModel>> getRecentPendingReports({int limit = 5});
}

class AdminDashboardRemoteDataSourceImpl implements AdminDashboardRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<DashboardStatsModel> getStats() async {
    // .select().count(CountOption.exact) بيرجع head request فقط (بدون تنزيل
    // الصفوف نفسها) والرد فيه حقل count الجاهز — أخف وأسرع من select عادي.
    final results = await Future.wait([
      supabase.from('users').select().count(CountOption.exact),
      supabase.from('agents').select().count(CountOption.exact),
      supabase
          .from('properties')
          .select()
          .eq('status', 'pending')
          .count(CountOption.exact),
      supabase
          .from('property_reports')
          .select()
          .eq('status', 'pending')
          .count(CountOption.exact),
      supabase
          .from('properties')
          .select()
          .eq('status', 'active')
          .count(CountOption.exact),
    ]);

    return DashboardStatsModel(
      totalUsers: results[0].count,
      totalAgents: results[1].count,
      pendingPropertiesCount: results[2].count,
      pendingReportsCount: results[3].count,
      activePropertiesCount: results[4].count,
    );
  }

  @override
  Future<List<PendingPropertyPreviewModel>> getRecentPendingProperties(
      {int limit = 5}) async {
    final rows = await supabase
        .from('properties')
        .select(
          'id, title, price, created_at, '
          'agents:agent_id(company_name, users:user_id(full_name)), '
          'property_images(image_url, is_primary)',
        )
        .eq('status', 'pending')
        .order('created_at', ascending: true) // الأقدم أولًا (FIFO)
        .limit(limit);

    return (rows as List)
        .map((row) =>
            PendingPropertyPreviewModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PendingReportPreviewModel>> getRecentPendingReports(
      {int limit = 5}) async {
    final rows = await supabase
        .from('property_reports')
        .select(
          'id, reason, created_at, property_id, '
          'reporter:reporter_user_id(full_name), '
          'property:property_id(title)',
        )
        .eq('status', 'pending')
        .order('created_at', ascending: false) // الأحدث أولًا
        .limit(limit);

    return (rows as List)
        .map((row) =>
            PendingReportPreviewModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }
}
