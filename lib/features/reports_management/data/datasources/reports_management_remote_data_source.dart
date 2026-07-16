import '../../../../core/network/supabase_config.dart';
import '../models/report_row_model.dart';

abstract class ReportsManagementRemoteDataSource {
  Future<List<ReportRowModel>> getReports({required String status});
  Future<void> markReviewed(String reportId);
  Future<void> disableReportedProperty({
    required String reportId,
    required String propertyId,
  });
}

class ReportsManagementRemoteDataSourceImpl
    implements ReportsManagementRemoteDataSource {
  // يستخدم متغيّر supabase العام مباشرة (core/network/supabase_config.dart).

  @override
  Future<List<ReportRowModel>> getReports({required String status}) async {
    final rows = await supabase
        .from('property_reports')
        .select(
          'id, reason, status, created_at, property_id, '
          'reporter:reporter_user_id(full_name), '
          'property:property_id(title)',
        )
        .eq('status', status)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((row) => ReportRowModel.fromSupabase(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markReviewed(String reportId) async {
    await supabase
        .from('property_reports')
        .update({'status': 'reviewed'}).eq('id', reportId);
  }

  @override
  Future<void> disableReportedProperty({
    required String reportId,
    required String propertyId,
  }) async {
    // تحديثان مستقلان — العقار والبلاغ بجدولين مختلفين، بدون علاقة FK تفرض
    // تحديث واحد ذرّي، فبيتنفّذوا بالتتابع (العقار أولًا، البلاغ بعده).
    await supabase.from('properties').update({
      'status': 'rejected',
      'rejection_reason': 'أُزيل من قبل الإدارة بناءً على بلاغ',
    }).eq('id', propertyId);

    await supabase
        .from('property_reports')
        .update({'status': 'reviewed'}).eq('id', reportId);
  }
}
