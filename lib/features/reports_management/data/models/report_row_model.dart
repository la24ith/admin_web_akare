import '../../domain/entities/report_row.dart';

class ReportRowModel extends ReportRow {
  const ReportRowModel({
    required super.id,
    required super.reason,
    required super.reporterName,
    required super.propertyId,
    required super.propertyTitle,
    required super.status,
    required super.createdAt,
  });

  /// يتوقّع صف من:
  /// property_reports.select(
  ///   'id, reason, status, created_at, property_id, '
  ///   'reporter:reporter_user_id(full_name), '
  ///   'property:property_id(title)'
  /// )
  factory ReportRowModel.fromSupabase(Map<String, dynamic> row) {
    final reporter = row['reporter'] as Map<String, dynamic>?;
    final property = row['property'] as Map<String, dynamic>?;

    return ReportRowModel(
      id: row['id'] as String,
      reason: row['reason'] as String? ?? '',
      reporterName: (reporter?['full_name'] as String?) ?? 'مستخدم',
      propertyId: row['property_id'] as String,
      propertyTitle: (property?['title'] as String?) ?? '',
      status: row['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
