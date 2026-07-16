import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UserRoleBadge extends StatelessWidget {
  final String role;
  const UserRoleBadge({super.key, required this.role});

  (String, Color, Color) get _display {
    switch (role) {
      case 'admin':
        return ('أدمن', AppColors.primary, AppColors.primaryLight);
      case 'agent':
        return ('وكيل', AppColors.accent, AppColors.accentLight);
      default:
        return ('مستخدم', AppColors.textSecondary, AppColors.divider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = _display;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
