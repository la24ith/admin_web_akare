import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/property_status_badge.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/property_list_row.dart';
import '../cubit/all_properties_cubit.dart';

class AllPropertiesScreen extends StatelessWidget {
  const AllPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AllPropertiesCubit>()..load(),
      child: const _AllPropertiesView(),
    );
  }
}

class _AllPropertiesView extends StatefulWidget {
  const _AllPropertiesView();

  @override
  State<_AllPropertiesView> createState() => _AllPropertiesViewState();
}

class _AllPropertiesViewState extends State<_AllPropertiesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDisable(BuildContext context, PropertyListRow row) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('تعطيل العقار'),
        content: Text(
          'هل أنت متأكد من تعطيل "${row.title}"؟\n'
          'رح تصير حالته "مرفوضة" فورًا وبيوصل إشعار للوكيل.',
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
            child: const Text('تعطيل'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AllPropertiesCubit>().disable(row.id);
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
            'كل العقارات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<AllPropertiesCubit, AllPropertiesState>(
            builder: (context, state) {
              final currentFilter = state is AllPropertiesLoaded
                  ? state.statusFilter
                  : PropertyStatusFilter.all;

              return LayoutBuilder(builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 700;
                final searchField = TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      context.read<AllPropertiesCubit>().setSearchQuery(v),
                  decoration: const InputDecoration(
                    hintText: 'ابحث بعنوان العقار...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                );

                final filterChips = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PropertyStatusFilter.values.map((filter) {
                    final selected = filter == currentFilter;
                    return ChoiceChip(
                      label: Text(filter.labelAr),
                      selected: selected,
                      selectedColor: AppColors.primaryLight,
                      onSelected: (_) =>
                          context.read<AllPropertiesCubit>().setStatusFilter(filter),
                    );
                  }).toList(),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchField,
                      const SizedBox(height: 12),
                      filterChips,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: filterChips),
                    const SizedBox(width: 16),
                    SizedBox(width: 280, child: searchField),
                  ],
                );
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AllPropertiesCubit, AllPropertiesState>(
              builder: (context, state) {
                if (state is AllPropertiesLoading ||
                    state is AllPropertiesInitial) {
                  return Column(
                    children: List.generate(
                      6,
                      (_) => const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ShimmerBox(height: 48),
                      ),
                    ),
                  );
                }

                if (state is AllPropertiesError) {
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
                              context.read<AllPropertiesCubit>().load(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final loaded = state as AllPropertiesLoaded;

                if (loaded.rows.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد عقارات مطابقة',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 48,
                      ),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(AppColors.background),
                        columns: const [
                          DataColumn(label: Text('العنوان')),
                          DataColumn(label: Text('السعر')),
                          DataColumn(label: Text('الحالة')),
                          DataColumn(label: Text('الوكيل')),
                          DataColumn(label: Text('المدينة')),
                          DataColumn(label: Text('التاريخ')),
                          DataColumn(label: Text('إجراءات')),
                        ],
                        rows: loaded.rows.map((row) {
                          final isDisabling =
                              loaded.disablingPropertyId == row.id;
                          final price =
                              NumberFormat.decimalPattern('ar').format(row.price);
                          final date = DateFormat('yyyy/MM/dd', 'ar')
                              .format(row.createdAt);

                          return DataRow(cells: [
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 260),
                                child: Text(row.title,
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataCell(Text('$price \$')),
                            DataCell(PropertyStatusBadge(status: row.status)),
                            DataCell(Text(row.agentName)),
                            DataCell(Text(row.cityName)),
                            DataCell(Text(date)),
                            DataCell(
                              isDisabling
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          tooltip: 'عرض التفاصيل',
                                          icon: const Icon(
                                              Icons.visibility_outlined,
                                              size: 20),
                                          onPressed: () => context.go(
                                              '/admin/properties/${row.id}/review'),
                                        ),
                                        if (row.status != 'rejected')
                                          IconButton(
                                            tooltip: 'تعطيل فوري',
                                            icon: const Icon(
                                                Icons.block_outlined,
                                                size: 20,
                                                color: AppColors.error),
                                            onPressed: () =>
                                                _confirmDisable(context, row),
                                          ),
                                      ],
                                    ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
