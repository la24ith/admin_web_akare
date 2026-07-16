import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/user_row.dart';
import '../cubit/users_management_cubit.dart';
import '../widgets/user_role_badge.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersManagementCubit>()..load(),
      child: const _UsersManagementView(),
    );
  }
}

class _UsersManagementView extends StatefulWidget {
  const _UsersManagementView();

  @override
  State<_UsersManagementView> createState() => _UsersManagementViewState();
}

class _UsersManagementViewState extends State<_UsersManagementView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleToggle(BuildContext context, UserRow user) async {
    // تأكيد مطلوب فقط قبل التعطيل (وليس عند إعادة التفعيل)
    if (user.isActive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('تعطيل الحساب'),
          content: Text(
            'هل أنت متأكد من تعطيل حساب "${user.fullName}"؟\n'
            'لن يتمكن من تسجيل الدخول بعد التعطيل.',
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

      if (confirmed != true || !context.mounted) return;
    }

    context.read<UsersManagementCubit>().toggleActive(user);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إدارة المستخدمين',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<UsersManagementCubit, UsersManagementState>(
            builder: (context, state) {
              final roleFilter = state is UsersManagementLoaded
                  ? state.roleFilter
                  : UserRoleFilter.all;
              final activeFilter = state is UsersManagementLoaded
                  ? state.activeFilter
                  : UserActiveFilter.all;

              return LayoutBuilder(builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 800;

                final roleChips = Wrap(
                  spacing: 8,
                  children: UserRoleFilter.values.map((filter) {
                    return ChoiceChip(
                      label: Text(filter.labelAr),
                      selected: filter == roleFilter,
                      selectedColor: AppColors.primaryLight,
                      onSelected: (_) => context
                          .read<UsersManagementCubit>()
                          .setRoleFilter(filter),
                    );
                  }).toList(),
                );

                final activeChips = Wrap(
                  spacing: 8,
                  children: UserActiveFilter.values.map((filter) {
                    return ChoiceChip(
                      label: Text(filter.labelAr),
                      selected: filter == activeFilter,
                      selectedColor: AppColors.primaryLight,
                      onSelected: (_) => context
                          .read<UsersManagementCubit>()
                          .setActiveFilter(filter),
                    );
                  }).toList(),
                );

                final searchField = TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      context.read<UsersManagementCubit>().setSearchQuery(v),
                  decoration: const InputDecoration(
                    hintText: 'ابحث بالاسم أو البريد أو الهاتف...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchField,
                      const SizedBox(height: 12),
                      roleChips,
                      const SizedBox(height: 8),
                      activeChips,
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: roleChips),
                        const SizedBox(width: 16),
                        activeChips,
                        const SizedBox(width: 16),
                        SizedBox(width: 280, child: searchField),
                      ],
                    ),
                  ],
                );
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<UsersManagementCubit, UsersManagementState>(
              builder: (context, state) {
                if (state is UsersManagementLoading ||
                    state is UsersManagementInitial) {
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

                if (state is UsersManagementError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 36),
                        const SizedBox(height: 10),
                        Text(state.message,
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () =>
                              context.read<UsersManagementCubit>().load(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final loaded = state as UsersManagementLoaded;

                if (loaded.users.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد مستخدمون مطابقون',
                        style: TextStyle(color: AppColors.textSecondary)),
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
                          DataColumn(label: Text('الاسم')),
                          DataColumn(label: Text('البريد الإلكتروني')),
                          DataColumn(label: Text('الهاتف')),
                          DataColumn(label: Text('الدور')),
                          DataColumn(label: Text('تاريخ التسجيل')),
                          DataColumn(label: Text('نشط')),
                        ],
                        rows: loaded.users.map((user) {
                          final isToggling = loaded.togglingUserId == user.id;
                          final date = DateFormat('yyyy/MM/dd', 'ar')
                              .format(user.createdAt);

                          return DataRow(cells: [
                            DataCell(Text(user.fullName)),
                            DataCell(Text(
                              user.email,
                              //  textDirection: TextDirection.LTR,
                            )),
                            DataCell(Text(
                              user.phone,
                              //  textDirection: TextDirection.LTR,
                            )),
                            DataCell(UserRoleBadge(role: user.role)),
                            DataCell(Text(date)),
                            DataCell(
                              isToggling
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Switch(
                                      value: user.isActive,
                                      activeColor: AppColors.success,
                                      onChanged: (_) =>
                                          _handleToggle(context, user),
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
