import '../../domain/entities/pending_agent.dart';

class PendingAgentModel extends PendingAgent {
  const PendingAgentModel({
    required super.agentId,
    required super.agentName,
    required super.companyName,
    required super.licenseNumber,
    required super.registeredAt,
  });

  /// يتوقّع صف من:
  /// agents.select(
  ///   'id, company_name, license_number, '
  ///   'users:user_id(full_name, created_at)'
  /// ).eq('is_verified_agent', false)
  ///
  /// ملاحظة: جدول agents بالمخطط المعطى ما فيه created_at، فاستخدمنا
  /// created_at تبع users (تاريخ إنشاء الحساب) كتاريخ تسجيل تقريبي.
  factory PendingAgentModel.fromSupabase(Map<String, dynamic> row) {
    final user = row['users'] as Map<String, dynamic>?;

    return PendingAgentModel(
      agentId: row['id'] as String,
      agentName: (user?['full_name'] as String?) ?? 'وكيل غير معروف',
      companyName: row['company_name'] as String?,
      licenseNumber: row['license_number'] as String?,
      registeredAt: DateTime.parse(
        (user?['created_at'] as String?) ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
