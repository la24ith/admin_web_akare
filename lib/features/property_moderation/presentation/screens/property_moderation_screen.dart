import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../cubit/property_moderation_cubit.dart';

class PropertyModerationScreen extends StatelessWidget {
  const PropertyModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PropertyModerationCubit>()..loadPendingProperties(),
      child: const _PropertyModerationView(),
    );
  }
}

class _PropertyModerationView extends StatelessWidget {
  const _PropertyModerationView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مراجعة العقارات',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                tooltip: 'تحديث',
                icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                onPressed: () =>
                    context.read<PropertyModerationCubit>().refresh(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'العقارات الأقدم أولًا — بانتظار قرارك',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<PropertyModerationCubit, PropertyModerationState>(
              builder: (context, state) {
                if (state is PropertyModerationLoading ||
                    state is PropertyModerationInitial) {
                  return ListView.separated(
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerBox(
                        height: 88, borderRadius: BorderRadius.all(Radius.circular(12))),
                  );
                }

                if (state is PropertyModerationError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 36),
                        const SizedBox(height: 10),
                        Text(state.message,
                            style:
                                const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context
                              .read<PropertyModerationCubit>()
                              .loadPendingProperties(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final items = (state as PropertyModerationLoaded).items;

                if (items.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt, size: 40, color: AppColors.success),
                        SizedBox(height: 10),
                        Text(
                          'لا توجد عقارات بانتظار المراجعة حاليًا 🎉',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final price =
                        NumberFormat.decimalPattern('ar').format(item.price);
                    final date =
                        DateFormat('yyyy/MM/dd', 'ar').format(item.createdAt);

                    return Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context
                            .go('/admin/properties/pending/${item.id}/review'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: item.imageUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: item.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) => Container(
                                            color: AppColors.divider,
                                            child: const Icon(
                                                Icons.home_outlined,
                                                color: AppColors.textHint),
                                          ),
                                        )
                                      : Container(
                                          color: AppColors.divider,
                                          child: const Icon(Icons.home_outlined,
                                              color: AppColors.textHint),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'الوكيل: ${item.agentName} · $date',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$price \$',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.chevron_left,
                                  color: AppColors.textHint),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
