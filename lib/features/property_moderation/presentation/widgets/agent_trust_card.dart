import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/property_moderation_entities.dart';

class AgentTrustCard extends StatelessWidget {
  final AgentTrustInfo agent;

  const AgentTrustCard({super.key, required this.agent});

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
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  agent.agentName.isNotEmpty ? agent.agentName[0] : 'و',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            agent.agentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (agent.isVerifiedAgent) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              size: 16, color: AppColors.primary),
                        ],
                      ],
                    ),
                    if (agent.companyName != null &&
                        agent.companyName!.trim().isNotEmpty)
                      Text(
                        agent.companyName!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (agent.licenseNumber != null &&
              agent.licenseNumber!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.badge_outlined,
                      size: 16, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text(
                    'رقم الترخيص: ${agent.licenseNumber}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: _TrustStat(
                  label: 'عقارات مقبولة',
                  value: agent.approvedPropertiesCount,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TrustStat(
                  label: 'عقارات مرفوضة',
                  value: agent.rejectedPropertiesCount,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          if (!agent.isVerifiedAgent) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 16, color: AppColors.accent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'هذا الوكيل غير موثّق بعد',
                      style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrustStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _TrustStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
