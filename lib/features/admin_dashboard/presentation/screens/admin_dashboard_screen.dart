import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/pending_property_tile.dart';
import '../widgets/pending_report_tile.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminDashboardCubit>()..loadOverview(),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'لوحة التحكم',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  tooltip: 'تحديث',
                  icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                  onPressed: () => context.read<AdminDashboardCubit>().refresh(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
                builder: (context, state) {
                  if (state is AdminDashboardLoading ||
                      state is AdminDashboardInitial) {
                    return const _DashboardShimmer();
                  }

                  if (state is AdminDashboardError) {
                    return _DashboardError(
                      message: state.message,
                      onRetry: () =>
                          context.read<AdminDashboardCubit>().loadOverview(),
                    );
                  }

                  final overview = (state as AdminDashboardLoaded).overview;
                  final stats = overview.stats;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final columns = width > 1100
                                ? 5
                                : width > 800
                                    ? 3
                                    : width > 500
                                        ? 2
                                        : 1;

                            final cards = [
                              DashboardStatCard(
                                label: 'إجمالي المستخدمين',
                                value: '${stats.totalUsers}',
                                icon: Icons.people_alt_outlined,
                                color: AppColors.primary,
                                onTap: () => context.go('/admin/users'),
                              ),
                              DashboardStatCard(
                                label: 'إجمالي الوكلاء',
                                value: '${stats.totalAgents}',
                                icon: Icons.badge_outlined,
                                color: AppColors.primary,
                                onTap: () => context.go('/admin/agents/pending'),
                              ),
                              DashboardStatCard(
                                label: 'عقارات قيد المراجعة',
                                value: '${stats.pendingPropertiesCount}',
                                icon: Icons.rule_folder_outlined,
                                color: AppColors.accent,
                                onTap: () =>
                                    context.go('/admin/properties/pending'),
                              ),
                              DashboardStatCard(
                                label: 'بلاغات معلّقة',
                                value: '${stats.pendingReportsCount}',
                                icon: Icons.flag_outlined,
                                color: AppColors.error,
                                onTap: () => context.go('/admin/reports'),
                              ),
                              DashboardStatCard(
                                label: 'عقارات نشطة',
                                value: '${stats.activePropertiesCount}',
                                icon: Icons.home_work_outlined,
                                color: AppColors.success,
                                onTap: () => context.go('/admin/properties'),
                              ),
                            ];

                            return GridView.count(
                              crossAxisCount: columns,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 1.5,
                              children: cards,
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 900;
                            final panels = [
                              _SectionPanel(
                                title: 'بانتظار المراجعة',
                                emptyText: 'لا توجد عقارات قيد المراجعة حاليًا',
                                onSeeAll: () =>
                                    context.go('/admin/properties/pending'),
                                itemCount: overview.recentPendingProperties.length,
                                itemBuilder: (i) => PendingPropertyTile(
                                  property: overview.recentPendingProperties[i],
                                  onTap: () => context.go(
                                    '/admin/properties/pending/'
                                    '${overview.recentPendingProperties[i].id}/review',
                                  ),
                                ),
                              ),
                              _SectionPanel(
                                title: 'بلاغات حديثة',
                                emptyText: 'لا توجد بلاغات معلّقة حاليًا',
                                onSeeAll: () => context.go('/admin/reports'),
                                itemCount: overview.recentPendingReports.length,
                                itemBuilder: (i) => PendingReportTile(
                                  report: overview.recentPendingReports[i],
                                  onTap: () => context.go(
                                    '/admin/properties/pending/'
                                    '${overview.recentPendingReports[i].propertyId}/review',
                                  ),
                                ),
                              ),
                            ];

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: panels[0]),
                                  const SizedBox(width: 16),
                                  Expanded(child: panels[1]),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                panels[0],
                                const SizedBox(height: 16),
                                panels[1],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  final String title;
  final String emptyText;
  final VoidCallback onSeeAll;
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const _SectionPanel({
    required this.title,
    required this.emptyText,
    required this.onSeeAll,
    required this.itemCount,
    required this.itemBuilder,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.divider),
          if (itemCount == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  emptyText,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textHint),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, i) => itemBuilder(i),
            ),
        ],
      ),
    );
  }
}

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.5,
      children: List.generate(
        5,
        (_) => const ShimmerBox(
          height: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 36),
          const SizedBox(height: 10),
          Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}
