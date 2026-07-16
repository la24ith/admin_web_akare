import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/report_row.dart';
import '../cubit/reports_management_cubit.dart';

class ReportsManagementScreen extends StatelessWidget {
  const ReportsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportsManagementCubit>()..load(),
      child: const _ReportsManagementView(),
    );
  }
}

class _ReportsManagementView extends StatelessWidget {
  const _ReportsManagementView();

  Future<void> _confirmDisable(BuildContext context, ReportRow report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('تعطيل العقار'),
        content: Text(
          'هل تريد تعطيل "${report.propertyTitle}" بناءً على هذا البلاغ؟\n'
          'رح تصير حالة العقار "مرفوضة" وبيوصل إشعار للوكيل.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تعطيل العقار'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ReportsManagementCubit>().disableProperty(
            reportId: report.id,
            propertyId: report.propertyId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إدارة البلاغات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ReportsManagementCubit, ReportsManagementState>(
            builder: (context, state) {
              final currentFilter = state is ReportsManagementLoaded
                  ? state.filter
                  : ReportStatusFilter.pending;

              return Wrap(
                spacing: 8,
                children: ReportStatusFilter.values.map((filter) {
                  return ChoiceChip(
                    label: Text(filter.labelAr),
                    selected: filter == currentFilter,
                    selectedColor: AppColors.primaryLight,
                    onSelected: (_) =>
                        context.read<ReportsManagementCubit>().setFilter(filter),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ReportsManagementCubit, ReportsManagementState>(
              builder: (context, state) {
                if (state is ReportsManagementLoading ||
                    state is ReportsManagementInitial) {
                  return ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerBox(
                      height: 90,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  );
                }

                if (state is ReportsManagementError) {
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
                          onPressed: () =>
                              context.read<ReportsManagementCubit>().load(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final loaded = state as ReportsManagementLoaded;

                if (loaded.reports.isEmpty) {
                  return const Center(
                    child: Text('لا توجد بلاغات هون حاليًا',
                        style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                return ListView.separated(
                  itemCount: loaded.reports.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final report = loaded.reports[index];
                    final isProcessing = loaded.processingReportId == report.id;
                    final date =
                        DateFormat('yyyy/MM/dd', 'ar').format(report.createdAt);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.flag_outlined,
                                color: AppColors.error, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => context.go(
                                      '/admin/properties/${report.propertyId}/review'),
                                  child: Text(
                                    report.propertyTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  report.reason,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'بلّغ عنه ${report.reporterName} · $date',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (report.status == ReportStatusFilter.pending.dbValue)
                            isProcessing
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () => context
                                            .read<ReportsManagementCubit>()
                                            .resolveWithoutAction(report.id),
                                        child: const Text(
                                          'تمت المراجعة، لا إجراء',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      TextButton(
                                        onPressed: () =>
                                            _confirmDisable(context, report),
                                        style: TextButton.styleFrom(
                                            foregroundColor: AppColors.error),
                                        child: const Text(
                                          'تعطيل العقار',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.check_circle_outline,
                                  color: AppColors.success, size: 20),
                            ),
                        ],
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
