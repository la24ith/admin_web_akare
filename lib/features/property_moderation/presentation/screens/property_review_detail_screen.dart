import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/property_moderation_entities.dart';
import '../cubit/property_review_detail_cubit.dart';
import '../widgets/agent_trust_card.dart';
import '../widgets/property_image_gallery.dart';
import '../widgets/reject_reason_dialog.dart';

class PropertyReviewDetailScreen extends StatelessWidget {
  final String propertyId;
  const PropertyReviewDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PropertyReviewDetailCubit>()..loadDetail(propertyId),
      child: _PropertyReviewDetailView(propertyId: propertyId),
    );
  }
}

class _PropertyReviewDetailView extends StatelessWidget {
  final String propertyId;
  const _PropertyReviewDetailView({required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyReviewDetailCubit, PropertyReviewDetailState>(
      listener: (context, state) {
        if (state is PropertyReviewActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              content: Text(state.message),
            ),
          );
          context.go('/admin/properties/pending');
        }
        if (state is PropertyReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PropertyReviewLoading ||
            state is PropertyReviewInitial ||
            state is PropertyReviewActionSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PropertyReviewError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 36),
                const SizedBox(height: 10),
                Text(state.message,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context
                      .read<PropertyReviewDetailCubit>()
                      .loadDetail(propertyId),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final loaded = state as PropertyReviewLoaded;
        return _ReviewContent(detail: loaded.detail, isSubmitting: loaded.isSubmitting);
      },
    );
  }
}

class _ReviewContent extends StatelessWidget {
  final PropertyReviewDetail detail;
  final bool isSubmitting;

  const _ReviewContent({required this.detail, required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat.decimalPattern('ar').format(detail.price);
    final date = DateFormat('yyyy/MM/dd', 'ar').format(detail.createdAt);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/admin/properties/pending'),
                icon: const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 4),
              const Text(
                'مراجعة العقار',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final mainColumn = _MainDetails(
                    detail: detail,
                    priceFormatted: priceFormatted,
                    date: date,
                  );
                  final sideColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AgentTrustCard(agent: detail.agent),
                      const SizedBox(height: 16),
                      _ActionsCard(detail: detail, isSubmitting: isSubmitting),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: mainColumn),
                        const SizedBox(width: 20),
                        SizedBox(width: 320, child: sideColumn),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      mainColumn,
                      const SizedBox(height: 20),
                      sideColumn,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainDetails extends StatelessWidget {
  final PropertyReviewDetail detail;
  final String priceFormatted;
  final String date;

  const _MainDetails({
    required this.detail,
    required this.priceFormatted,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyImageGallery(imageUrls: detail.imageUrls),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      detail.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '$priceFormatted \$',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'أُضيف بتاريخ $date',
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _SpecChip(
                    icon: Icons.category_outlined,
                    label: detail.propertyTypeName,
                  ),
                  _SpecChip(
                    icon: detail.listingType == 'rent'
                        ? Icons.key_outlined
                        : Icons.sell_outlined,
                    label: detail.listingType == 'rent' ? 'للإيجار' : 'للبيع',
                  ),
                  _SpecChip(
                    icon: Icons.location_city_outlined,
                    label: detail.cityName,
                  ),
                  _SpecChip(
                    icon: Icons.square_foot_outlined,
                    label: '${detail.areaSqm.toStringAsFixed(0)} م²',
                  ),
                  if (detail.roomsCount != null)
                    _SpecChip(
                      icon: Icons.bed_outlined,
                      label: '${detail.roomsCount} غرف',
                    ),
                  if (detail.bathroomsCount != null)
                    _SpecChip(
                      icon: Icons.bathtub_outlined,
                      label: '${detail.bathroomsCount} حمامات',
                    ),
                ],
              ),
              if (detail.addressText != null &&
                  detail.addressText!.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place_outlined,
                        size: 18, color: AppColors.textHint),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        detail.addressText!,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              const Text(
                'الوصف',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                detail.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // ملاحظة: خريطة flutter_map (نفس LocationCard تبع تطبيق الزبون) ممكن
        // تُضاف هون لو عندك detail.latitude/detail.longitude — حذفناها من
        // هاي النسخة لتبسيط الاعتماديات، انسخها كما هي من property_details
        // بمشروع الموبايل لو حابب تفعّلها.
      ],
    );
  }
}

class _SpecChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final PropertyReviewDetail detail;
  final bool isSubmitting;

  const _ActionsCard({required this.detail, required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'قرار المراجعة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: isSubmitting
                  ? null
                  : () => context.read<PropertyReviewDetailCubit>().approve(),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline, size: 20),
              label: const Text('قبول ونشر العقار'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final reason = await showRejectReasonDialog(context);
                      if (reason != null && context.mounted) {
                        context.read<PropertyReviewDetailCubit>().reject(reason);
                      }
                    },
              icon: const Icon(Icons.cancel_outlined, size: 20),
              label: const Text('رفض العقار'),
            ),
          ),
        ],
      ),
    );
  }
}
