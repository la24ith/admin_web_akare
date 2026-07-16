import 'package:equatable/equatable.dart';

class PropertyListRow extends Equatable {
  final String id;
  final String title;
  final double price;
  final String status; // pending | active | rejected | sold | rented
  final String agentName;
  final String cityName;
  final String? imageUrl;
  final DateTime createdAt;

  const PropertyListRow({
    required this.id,
    required this.title,
    required this.price,
    required this.status,
    required this.agentName,
    required this.cityName,
    required this.imageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, title, price, status, agentName, cityName, imageUrl, createdAt];
}

/// خيارات الفلترة بالحالة — نفس القيم المستخدمة بعمود properties.status،
/// بالإضافة لـ 'all' لعرض الكل.
enum PropertyStatusFilter { all, pending, active, rejected, sold, rented }

extension PropertyStatusFilterX on PropertyStatusFilter {
  String? get dbValue => this == PropertyStatusFilter.all ? null : name;

  String get labelAr {
    switch (this) {
      case PropertyStatusFilter.all:
        return 'الكل';
      case PropertyStatusFilter.pending:
        return 'معلّقة';
      case PropertyStatusFilter.active:
        return 'نشطة';
      case PropertyStatusFilter.rejected:
        return 'مرفوضة';
      case PropertyStatusFilter.sold:
        return 'مباعة';
      case PropertyStatusFilter.rented:
        return 'مؤجرة';
    }
  }
}
