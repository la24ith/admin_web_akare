import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PropertyStatusBadge extends StatelessWidget {
  final String status;
  const PropertyStatusBadge({super.key, required this.status});

  String get _label {
    switch (status) {
      case 'pending':
        return 'معلّقة';
      case 'active':
        return 'نشطة';
      case 'rejected':
        return 'مرفوضة';
      case 'sold':
        return 'مباعة';
      case 'rented':
        return 'مؤجرة';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    final bgColor = AppColors.statusColorLight(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
