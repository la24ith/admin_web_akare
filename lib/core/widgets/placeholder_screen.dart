import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// شاشة مؤقتة لأي ميزة لسا ما اتبنت (property_moderation, all_properties, ...).
/// كل ميزة رح تستبدل هاد الـ Widget بشاشتها الفعلية (Cubit + View) بالخطوة تبعها.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.construction_outlined,
              size: 40, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'هذه الشاشة قيد الإنشاء',
            style: TextStyle(fontSize: 13, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
