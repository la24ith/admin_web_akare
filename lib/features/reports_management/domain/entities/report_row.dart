import 'package:equatable/equatable.dart';

class ReportRow extends Equatable {
  final String id;
  final String reason;
  final String reporterName;
  final String propertyId;
  final String propertyTitle;
  final String status; // pending | reviewed
  final DateTime createdAt;

  const ReportRow({
    required this.id,
    required this.reason,
    required this.reporterName,
    required this.propertyId,
    required this.propertyTitle,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, reason, reporterName, propertyId, propertyTitle, status, createdAt];
}

enum ReportStatusFilter { pending, reviewed }

extension ReportStatusFilterX on ReportStatusFilter {
  String get dbValue => name;

  String get labelAr => this == ReportStatusFilter.pending ? 'معلّقة' : 'تمت مراجعتها';
}
