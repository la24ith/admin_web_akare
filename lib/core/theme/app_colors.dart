import 'package:flutter/material.dart';

/// نفس هوية الألوان المستخدمة بتطبيقي الزبون والوكيل — موحّدة عبر كل التطبيقات.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0E6E5C); // teal
  static const Color primaryDark = Color(0xFF0A4F42);
  static const Color primaryLight = Color(0xFFE3F1EE);

  static const Color accent = Color(0xFFE7A94C); // ذهبي
  static const Color accentLight = Color(0xFFFBEDD8);

  static const Color error = Color(0xFFD64545);
  static const Color errorLight = Color(0xFFFBE4E4);

  static const Color success = Color(0xFF2E9E5B);
  static const Color successLight = Color(0xFFE1F5E8);

  static const Color warning = accent;
  static const Color warningLight = accentLight;

  static const Color textPrimary = Color(0xFF1C1F1E);
  static const Color textSecondary = Color(0xFF6B7674);
  static const Color textHint = Color(0xFFA0A8A6);

  static const Color background = Color(0xFFF6F8F7);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE3E7E5);
  static const Color divider = Color(0xFFECEFEE);

  /// ألوان بادجات حالة العقار — نفس المستخدمة بتطبيق الوكيل
  static Color statusColor(String status) {
    switch (status) {
      case 'pending':
        return accent;
      case 'active':
        return success;
      case 'rejected':
        return error;
      case 'sold':
      case 'rented':
        return textSecondary;
      default:
        return textSecondary;
    }
  }

  static Color statusColorLight(String status) {
    switch (status) {
      case 'pending':
        return accentLight;
      case 'active':
        return successLight;
      case 'rejected':
        return errorLight;
      case 'sold':
      case 'rented':
        return const Color(0xFFEDEFEE);
      default:
        return const Color(0xFFEDEFEE);
    }
  }
}
