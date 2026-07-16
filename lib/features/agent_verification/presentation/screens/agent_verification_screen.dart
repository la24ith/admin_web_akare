import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../cubit/agent_verification_cubit.dart';

class AgentVerificationScreen extends StatelessWidget {
  const AgentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AgentVerificationCubit>()..load(),
      child: const _AgentVerificationView(),
    );
  }
}

class _AgentVerificationView extends StatelessWidget {
  const _AgentVerificationView();

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
                'توثيق الوكلاء',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                tooltip: 'تحديث',
                icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                onPressed: () => context.read<AgentVerificationCubit>().load(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'الوكلاء الذين لم يتم توثيقهم بعد',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AgentVerificationCubit, AgentVerificationState>(
              builder: (context, state) {
                if (state is AgentVerificationLoading ||
                    state is AgentVerificationInitial) {
                  return ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerBox(
                      height: 84,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  );
                }

                if (state is AgentVerificationError) {
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
                              context.read<AgentVerificationCubit>().load(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final loaded = state as AgentVerificationLoaded;

                if (loaded.agents.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_outlined,
                            size: 40, color: AppColors.success),
                        SizedBox(height: 10),
                        Text(
                          'كل الوكلاء موثّقون حاليًا 🎉',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: loaded.agents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final agent = loaded.agents[index];
                    final isVerifying = loaded.verifyingAgentId == agent.agentId;
                    final date =
                        DateFormat('yyyy/MM/dd', 'ar').format(agent.registeredAt);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              agent.agentName.isNotEmpty ? agent.agentName[0] : 'و',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agent.agentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    if (agent.companyName != null &&
                                        agent.companyName!.trim().isNotEmpty)
                                      agent.companyName!,
                                    if (agent.licenseNumber != null &&
                                        agent.licenseNumber!.trim().isNotEmpty)
                                      'ترخيص: ${agent.licenseNumber}',
                                    'انضم بتاريخ $date',
                                  ].join(' · '),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          isVerifying
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => context
                                      .read<AgentVerificationCubit>()
                                      .verify(agent.agentId),
                                  icon: const Icon(Icons.verified_outlined,
                                      size: 18),
                                  label: const Text('توثيق'),
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
