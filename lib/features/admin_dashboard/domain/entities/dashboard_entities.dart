import 'package:equatable/equatable.dart';

/// البطاقات الإحصائية أعلى لوحة التحكم
class DashboardStatsEntity extends Equatable {
  final int totalUsers;
  final int totalAgents;
  final int pendingPropertiesCount;
  final int pendingReportsCount;
  final int activePropertiesCount;

  const DashboardStatsEntity({
    required this.totalUsers,
    required this.totalAgents,
    required this.pendingPropertiesCount,
    required this.pendingReportsCount,
    required this.activePropertiesCount,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        totalAgents,
        pendingPropertiesCount,
        pendingReportsCount,
        activePropertiesCount,
      ];
}

/// عنصر مختصر لعقار "بانتظار المراجعة" — لا علاقة له بـ PropertyEntity
/// الكاملة تبع تطبيق الزبون، هاي نسخة خفيفة كافية لقسم اللوحة فقط.
class PendingPropertyPreview extends Equatable {
  final String id;
  final String title;
  final double price;
  final String agentName;
  final String? imageUrl;
  final DateTime createdAt;

  const PendingPropertyPreview({
    required this.id,
    required this.title,
    required this.price,
    required this.agentName,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, price, agentName, imageUrl, createdAt];
}

/// عنصر مختصر لبلاغ "حديث" بقسم اللوحة
class PendingReportPreview extends Equatable {
  final String id;
  final String reason;
  final String reporterName;
  final String propertyId;
  final String propertyTitle;
  final DateTime createdAt;

  const PendingReportPreview({
    required this.id,
    required this.reason,
    required this.reporterName,
    required this.propertyId,
    required this.propertyTitle,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, reason, reporterName, propertyId, propertyTitle, createdAt];
}

/// كل بيانات شاشة لوحة التحكم مجمّعة بكائن واحد لتبسيط الـ Cubit/State
class DashboardOverview extends Equatable {
  final DashboardStatsEntity stats;
  final List<PendingPropertyPreview> recentPendingProperties;
  final List<PendingReportPreview> recentPendingReports;

  const DashboardOverview({
    required this.stats,
    required this.recentPendingProperties,
    required this.recentPendingReports,
  });

  @override
  List<Object?> get props =>
      [stats, recentPendingProperties, recentPendingReports];
}
