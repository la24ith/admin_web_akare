import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

const _presetReasons = [
  'صور غير واضحة أو غير كافية',
  'السعر غير منطقي أو مضلّل',
  'العنوان أو الوصف غير دقيق',
  'الموقع الجغرافي غير صحيح',
  'محتوى مخالف لسياسات المنصة',
];

/// يفتح Dialog لاختيار/كتابة سبب الرفض، ويرجع النص النهائي أو null لو أُلغي.
Future<String?> showRejectReasonDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _RejectReasonDialog(),
  );
}

class _RejectReasonDialog extends StatefulWidget {
  const _RejectReasonDialog();

  @override
  State<_RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  String? _selectedPreset;
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String get _finalReason {
    final custom = _customController.text.trim();
    if (_selectedPreset != null && custom.isNotEmpty) {
      return '$_selectedPreset — $custom';
    }
    if (_selectedPreset != null) return _selectedPreset!;
    return custom;
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _finalReason.trim().isNotEmpty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Text('سبب رفض العقار'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر سببًا جاهزًا أو اكتب سببًا مخصصًا (يظهر للوكيل)',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetReasons.map((reason) {
                final selected = _selectedPreset == reason;
                return ChoiceChip(
                  label: Text(reason, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  selectedColor: AppColors.primaryLight,
                  onSelected: (_) => setState(
                    () => _selectedPreset = selected ? null : reason,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _customController,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'تفاصيل إضافية (اختياري)',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          onPressed: canSubmit
              ? () => Navigator.of(context).pop(_finalReason.trim())
              : null,
          child: const Text('تأكيد الرفض'),
        ),
      ],
    );
  }
}
