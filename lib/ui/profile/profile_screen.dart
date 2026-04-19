import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/subscription_tier.dart';
import '../../theme/app_colors.dart';
import '../core/widgets/app_form_field.dart';
import 'profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Profile Card with Tier Badge ──
            _ProfileCard(vm: vm),
            const SizedBox(height: 16),

            // ── Subscription Plan Card ──
            _SubscriptionCard(vm: vm),
            const SizedBox(height: 16),

            // ── Activity Stats ──
            _StatsCard(vm: vm),
            const SizedBox(height: 16),

            // ── Account Info ──
            _AccountInfoCard(vm: vm),
            const SizedBox(height: 16),

            // ── Verify Phone ──
            // _VerifyPhoneCard(vm: vm),
            // const SizedBox(height: 16),

            // ── Brand Kit / Institution ──
            _BrandKitCard(vm: vm),
            const SizedBox(height: 16),

            // ── Default Campaign Preferences ──
            _PreferencesCard(vm: vm),
            const SizedBox(height: 16),

            // ── Notifications ──
            // _NotificationsCard(vm: vm),
            // const SizedBox(height: 16),

            // ── Security ──
            // _SecurityCard(vm: vm),
            // const SizedBox(height: 16),

            // ── Help & Support ──
            _HelpCard(),
            const SizedBox(height: 16),

            // ── Danger Zone ──
            _DangerZoneCard(vm: vm),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 1. Profile Card with Tier Badge
// ─────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _ProfileCard({required this.vm});

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
                    // Role badge
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
                    // Tier badge
                    _TierBadge(tier: profile.tier),
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

class _TierBadge extends StatelessWidget {
  final SubscriptionTier tier;
  const _TierBadge({required this.tier});

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

// ─────────────────────────────────────────────
// 2. Subscription Plan Card
// ─────────────────────────────────────────────
class _SubscriptionCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _SubscriptionCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final profile = vm.profile;
    final tier = profile.tier;
    final isFree = tier == SubscriptionTier.free;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
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

          // Images usage
          _UsageBar(
            icon: Icons.image_outlined,
            label: 'Images',
            used: profile.usedImages,
            total: tier.monthlyImages,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 14),

          // Videos usage
          _UsageBar(
            icon: Icons.videocam_outlined,
            label: 'Videos',
            used: profile.usedVideos,
            total: tier.monthlyVideos,
            color: const Color(0xFF6A1B9A),
          ),
          const SizedBox(height: 14),

          // Text campaigns
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

          // Upgrade banner for free / Manage Plan for paid
          if (isFree)
            _UpgradeBanner(onTap: () => _showPlanComparison(context, vm))
          else
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => _showPlanComparison(context, vm),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
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

// ─────────────────────────────────────────────
// 3. Activity Stats
// ─────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _StatsCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final p = vm.profile;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, size: 22, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Your Activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(
                icon: Icons.campaign_outlined,
                value: '${p.totalCampaigns}',
                label: 'Campaigns',
                color: const Color(0xFF1565C0),
              ),
              _StatTile(
                icon: Icons.image_outlined,
                value: '${p.totalImages}',
                label: 'Images',
                color: const Color(0xFF6A1B9A),
              ),
              _StatTile(
                icon: Icons.videocam_outlined,
                value: '${p.totalVideos}',
                label: 'Videos',
                color: const Color(0xFFE65100),
              ),
              _StatTile(
                icon: Icons.description_outlined,
                value: '${p.totalPrintMaterials}',
                label: 'Print',
                color: const Color(0xFF2E7D32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. Account Info
// ─────────────────────────────────────────────
class _AccountInfoCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _AccountInfoCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.person_outline, title: 'Account Info'),
          const SizedBox(height: 6),
          Text(
            'Your email is linked to your Google account and cannot be changed here.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          const AppFormLabel('EMAIL ADDRESS', icon: Icons.email_outlined),
          const SizedBox(height: 8),
          AppTextField(hint: vm.profile.email, enabled: false),
          const SizedBox(height: 24),

          const AppFormLabel(
            'PHONE / WHATSAPP NUMBER',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 8),
          AppPhoneField(
            key: ValueKey(vm.dialCode),
            controller: vm.phoneController,
            dialCode: vm.dialCode,
          ),
          const SizedBox(height: 6),
          Text(
            'This number is pre-filled in your campaign CTAs.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: vm.isSaving
                  ? null
                  : () async {
                      await vm.saveAccountChanges();
                      if (!context.mounted) return;
                      final msg = vm.saveMessage;
                      if (msg != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: msg.startsWith('Failed')
                                ? const Color(0xFFB00020)
                                : const Color(0xFF2E7D32),
                          ),
                        );
                      }
                    },
              icon: vm.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(
                vm.isSaving ? 'Saving...' : 'Save Changes',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.secondary.withValues(
                  alpha: 0.7,
                ),
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 5. Brand Kit / Institution
// ─────────────────────────────────────────────
class _BrandKitCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _BrandKitCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.business_outlined,
            title: 'Brand Kit / Institution',
          ),
          const SizedBox(height: 6),
          Text(
            'Save once, auto-fill everywhere. These details pre-fill your Print Materials, Reel Scripts & Image forms.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          const AppFormLabel('INSTITUTION / BRAND NAME'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.institutionController,
            hint: 'e.g. ABC Academy, Global Education Hub',
          ),
          const SizedBox(height: 16),

          const AppFormLabel('TAGLINE / SLOGAN'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.taglineController,
            hint: 'e.g. Your Gateway to Global Education',
          ),
          const SizedBox(height: 16),

          const AppFormLabel('INSTITUTION EMAIL'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.institutionEmailController,
            hint: 'info@institution.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          const AppFormLabel('WEBSITE'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.websiteController,
            hint: 'www.institution.com',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),

          const AppFormLabel('ADDRESS'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.addressController,
            hint: 'Full address for print materials',
          ),
          const SizedBox(height: 16),

          const AppFormLabel('KEY OFFERINGS / COURSES'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.keyOfferingsController,
            hint: 'MBBS in Russia\nMBBS in Kazakhstan\nNEET Coaching',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          const AppFormLabel('UNIQUE SELLING POINTS'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.uspController,
            hint: '15+ years of experience\n500+ students placed globally',
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: vm.isSavingBrandKit
                        ? null
                        : () => vm.resetBrandKit(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: vm.isSavingBrandKit
                        ? null
                        : () async {
                            await vm.saveBrandKit();
                            if (!context.mounted) return;
                            final msg = vm.brandKitMessage;
                            if (msg != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: msg.startsWith('Failed')
                                      ? const Color(0xFFB00020)
                                      : const Color(0xFF2E7D32),
                                ),
                              );
                            }
                          },
                    icon: vm.isSavingBrandKit
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      vm.isSavingBrandKit ? 'Saving...' : 'Save',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.secondary.withValues(
                        alpha: 0.7,
                      ),
                      disabledForegroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 7. Default Campaign Preferences
// ─────────────────────────────────────────────
class _PreferencesCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _PreferencesCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.tune, title: 'Default Preferences'),
          const SizedBox(height: 6),
          Text(
            'Pre-fill your Generator & Studio forms with these defaults.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          AppDropdownField(
            label: 'DEFAULT COUNTRY',
            value: vm.profile.defaultCountry,
            items: const [
              'India',
              'USA',
              'UK',
              'Canada',
              'Australia',
              'UAE',
              'Germany',
              'Russia',
            ],
            onChanged: (val) => vm.updateDefaultCountry(val!),
          ),

          AppDropdownField(
            label: 'DEFAULT LANGUAGE',
            value: vm.profile.defaultLanguage,
            items: const [
              'Hinglish',
              'English',
              'Hindi',
              'Spanish',
              'French',
              'Arabic',
            ],
            onChanged: (val) => vm.updateDefaultLanguage(val!),
          ),

          AppDropdownField(
            label: 'DEFAULT AUDIENCE',
            value: vm.profile.defaultAudience,
            items: const [
              'Students (Class 10-12)',
              'College Students',
              'Parents',
              'Working Professionals',
              'Coaching Aspirants',
              'Study Abroad Seekers',
            ],
            onChanged: (val) => vm.updateDefaultAudience(val!),
          ),

          AppDropdownField(
            label: 'DEFAULT PLATFORM',
            value: vm.profile.defaultPlatform,
            items: const [
              'Instagram Reels',
              'YouTube Shorts',
              'TikTok',
              'Facebook Reels',
              'LinkedIn Video',
            ],
            onChanged: (val) => vm.updateDefaultPlatform(val!),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 8. Notifications
// ─────────────────────────────────────────────
// class _NotificationsCard extends StatelessWidget {
//   final ProfileViewModel vm;
//   const _NotificationsCard({required this.vm});

//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _SectionHeader(
//             icon: Icons.notifications_outlined,
//             title: 'Notifications',
//           ),
//           const SizedBox(height: 16),
//           _NotifToggle(
//             label: 'Campaign generation complete',
//             value: vm.profile.notifyOnComplete,
//             onChanged: vm.toggleNotifyOnComplete,
//           ),
//           _NotifToggle(
//             label: 'Weekly usage summary',
//             value: vm.profile.notifyWeeklySummary,
//             onChanged: vm.toggleNotifyWeeklySummary,
//           ),
//           _NotifToggle(
//             label: 'New feature announcements',
//             value: vm.profile.notifyNewFeatures,
//             onChanged: vm.toggleNotifyNewFeatures,
//           ),
//           _NotifToggle(
//             label: 'Subscription renewal reminder',
//             value: vm.profile.notifyRenewal,
//             onChanged: vm.toggleNotifyRenewal,
//           ),
//         ],
//       ),
//     );
//   }
// }

class _NotifToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: AppColors.primaryDark),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.secondary,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 9. Security
// ─────────────────────────────────────────────
class _SecurityCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _SecurityCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.shield_outlined, title: 'Security'),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.key_outlined,
            label: 'Change Password',
            onTap: vm.changePassword,
          ),
          _ActionTile(
            icon: Icons.phonelink_lock_outlined,
            label: 'Two-Factor Authentication',
            subtitle: 'Coming soon',
            onTap: null,
          ),
          _ActionTile(
            icon: Icons.devices_outlined,
            label: 'Active Sessions',
            subtitle: 'Coming soon',
            onTap: null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 10. Help & Support
// ─────────────────────────────────────────────
class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.help_outline, title: 'Help & Support'),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.chat_bubble_outline,
            label: 'Chat Support',
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.menu_book_outlined,
            label: 'How to Use Shiksha',
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.star_outline,
            label: 'Rate the App',
            onTap: () {},
          ),
          _ActionTile(
            icon: Icons.bug_report_outlined,
            label: 'Report a Bug',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 11. Danger Zone
// ─────────────────────────────────────────────
class _DangerZoneCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _DangerZoneCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber,
                size: 22,
                color: Color(0xFFD32F2F),
              ),
              const SizedBox(width: 8),
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.file_download_outlined,
            label: 'Export All Campaigns',
            subtitle: 'Download as PDF / ZIP',
            onTap: vm.exportAllCampaigns,
          ),
          _ActionTile(
            icon: Icons.logout,
            label: 'Sign Out',
            onTap: () => vm.signOut(context),
            color: AppColors.textSecondary,
          ),
          _ActionTile(
            icon: Icons.delete_forever_outlined,
            label: 'Delete Account & Data',
            onTap: vm.deleteAccount,
            color: const Color(0xFFD32F2F),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Plan Comparison Bottom Sheet
// ─────────────────────────────────────────────
void _showPlanComparison(BuildContext context, ProfileViewModel vm) {
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
                  // TODO: Connect payment backend
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

// ─────────────────────────────────────────────
// Shared Helpers
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }
}

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onPressed;

//   const _PrimaryButton({
//     required this.label,
//     required this.icon,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, size: 18),
//         label: Text(
//           label,
//           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.secondary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           elevation: 0,
//         ),
//       ),
//     );
//   }
// }

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? color;

  const _ActionTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.primaryDark;
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: disabled ? AppColors.textSecondary : tileColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: disabled ? AppColors.textSecondary : tileColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (!disabled)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
