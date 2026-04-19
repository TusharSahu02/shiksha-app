import 'package:flutter/material.dart';
import '../../../data/models/subscription_tier.dart';
import '../../../theme/app_colors.dart';
import '../profile_view_model.dart';

void showPlanComparison(BuildContext context, ProfileViewModel vm) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D0D0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pick the plan that fits your needs',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _PlanTile(
                        tier: SubscriptionTier.free,
                        isCurrent: vm.profile.tier == SubscriptionTier.free,
                        features: const [
                          '30 images / month',
                          '5 text campaigns / day',
                          'No video generation',
                          'Basic templates',
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PlanTile(
                        tier: SubscriptionTier.silver,
                        isCurrent: vm.profile.tier == SubscriptionTier.silver,
                        features: const [
                          '100 images / month',
                          'Unlimited text campaigns',
                          '30 videos / month',
                          'All templates & styles',
                          'Priority generation',
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PlanTile(
                        tier: SubscriptionTier.golden,
                        isCurrent: vm.profile.tier == SubscriptionTier.golden,
                        features: const [
                          '300 images / month',
                          'Unlimited text campaigns',
                          '90 videos / month',
                          'All templates & styles',
                          'Priority generation',
                          'Dedicated support',
                          'Custom branding',
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _PlanTile extends StatelessWidget {
  final SubscriptionTier tier;
  final bool isCurrent;
  final List<String> features;

  const _PlanTile({
    required this.tier,
    required this.isCurrent,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final isGolden = tier == SubscriptionTier.golden;
    final borderColor = isCurrent
        ? AppColors.secondary
        : isGolden
        ? const Color(0xFFD4A017)
        : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.secondary.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tier.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                tier.price,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isCurrent
                        ? AppColors.secondary
                        : const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isCurrent) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGolden
                      ? const Color(0xFFD4A017)
                      : AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Upgrade to ${tier.label}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
