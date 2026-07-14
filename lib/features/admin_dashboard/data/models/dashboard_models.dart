import '../../domain/entities/dashboard_entities.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalUsers,
    required super.totalAgents,
    required super.pendingPropertiesCount,
    required super.pendingReportsCount,
    required super.activePropertiesCount,
  });
}

class PendingPropertyPreviewModel extends PendingPropertyPreview {
  const PendingPropertyPreviewModel({
    required super.id,
    required super.title,
    required super.price,
    required super.agentName,
    required super.imageUrl,
    required super.createdAt,
  });

  /// يتوقّع صف من الاستعلام:
  /// properties.select(
  ///   'id, title, price, created_at, '
  ///   'agents:agent_id(company_name, users:user_id(full_name)), '
  ///   'property_images(image_url, is_primary)'
  /// )
  factory PendingPropertyPreviewModel.fromSupabase(Map<String, dynamic> row) {
    final agent = row['agents'] as Map<String, dynamic>?;
    final agentUser = agent?['users'] as Map<String, dynamic>?;
    final images = (row['property_images'] as List?) ?? const [];

    String? primaryImage;
    if (images.isNotEmpty) {
      final primary = images.firstWhere(
        (img) => img['is_primary'] == true,
        orElse: () => images.first,
      );
      primaryImage = primary['image_url'] as String?;
    }

    return PendingPropertyPreviewModel(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      price: double.tryParse(row['price'].toString()) ?? 0,
      agentName: (agentUser?['full_name'] as String?) ??
          (agent?['company_name'] as String?) ??
          'وكيل غير معروف',
      imageUrl: primaryImage,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}

class PendingReportPreviewModel extends PendingReportPreview {
  const PendingReportPreviewModel({
    required super.id,
    required super.reason,
    required super.reporterName,
    required super.propertyId,
    required super.propertyTitle,
    required super.createdAt,
  });

  /// يتوقّع صف من الاستعلام:
  /// property_reports.select(
  ///   'id, reason, created_at, property_id, '
  ///   'reporter:reporter_user_id(full_name), '
  ///   'property:property_id(title)'
  /// )
  factory PendingReportPreviewModel.fromSupabase(Map<String, dynamic> row) {
    final reporter = row['reporter'] as Map<String, dynamic>?;
    final property = row['property'] as Map<String, dynamic>?;

    return PendingReportPreviewModel(
      id: row['id'] as String,
      reason: row['reason'] as String? ?? '',
      reporterName: (reporter?['full_name'] as String?) ?? 'مستخدم',
      propertyId: row['property_id'] as String,
      propertyTitle: (property?['title'] as String?) ?? '',
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
