import 'package:flutter/material.dart';
import '../../../data/models/subscription_tier.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';

class ProfileCard extends StatelessWidget {
  final ProfileViewModel vm;
  const ProfileCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final profile = vm.profile;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: profile.photoUrl.isNotEmpty
                ? Image.network(
                    profile.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => _buildInitial(profile.name),
                  )
                : _buildInitial(profile.name),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        profile.role,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TierBadge(tier: profile.tier),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TierBadge extends StatelessWidget {
  final SubscriptionTier tier;
  const TierBadge({super.key, required this.tier});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon) = switch (tier) {
      SubscriptionTier.free => (
        const Color(0xFFF5F5F5),
        AppColors.textSecondary,
        Icons.lock_outline,
      ),
      SubscriptionTier.silver => (
        const Color(0xFFE3F2FD),
        const Color(0xFF1565C0),
        Icons.bolt,
      ),
      SubscriptionTier.golden => (
        const Color(0xFFFFF8E1),
        const Color(0xFFE65100),
        Icons.workspace_premium,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            tier.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
