import 'package:flutter/material.dart';
import '../../../data/models/subscription_tier.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';
import 'plan_comparison_sheet.dart';

class SubscriptionCard extends StatelessWidget {
  final ProfileViewModel vm;
  const SubscriptionCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final profile = vm.profile;
    final tier = profile.tier;
    final isFree = tier == SubscriptionTier.free;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.workspace_premium,
                size: 22,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                '${tier.label} Plan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              Text(
                tier.price,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),

          if (profile.renewalDate != null) ...[
            const SizedBox(height: 4),
            Text(
              'Renews on ${_formatDate(profile.renewalDate!)}',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],

          const SizedBox(height: 20),

          _UsageBar(
            icon: Icons.image_outlined,
            label: 'Images',
            used: profile.usedImages,
            total: tier.monthlyImages,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 14),

          _UsageBar(
            icon: Icons.videocam_outlined,
            label: 'Videos',
            used: profile.usedVideos,
            total: tier.monthlyVideos,
            color: const Color(0xFF6A1B9A),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(Icons.text_fields, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Text(
                'Text Campaigns',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              Text(
                tier.dailyTexts == -1
                    ? 'Unlimited \u2713'
                    : '${tier.dailyTexts} / day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (isFree)
            _UpgradeBanner(onTap: () => showPlanComparison(context, vm))
          else
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => showPlanComparison(context, vm),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: BorderSide(color: AppColors.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Manage Plan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _UsageBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final int used;
  final int total;
  final Color color;

  const _UsageBar({
    required this.icon,
    required this.label,
    required this.used,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final blocked = total == 0;
    final progress = blocked ? 0.0 : (used / total).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
            const Spacer(),
            Text(
              blocked ? 'Locked \u{1F512}' : '$used / $total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: blocked ? AppColors.textSecondary : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation(
              blocked ? AppColors.textSecondary : color,
            ),
          ),
        ),
      ],
    );
  }
}

class _UpgradeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _UpgradeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary.withValues(alpha: 0.12),
              AppColors.secondary.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.rocket_launch, size: 20, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Silver',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    'Unlock videos, 100 images/month & more',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}
