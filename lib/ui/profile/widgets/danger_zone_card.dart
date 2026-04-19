import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../auth/auth_screen.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';
import 'shared_widgets.dart';

class DangerZoneCard extends StatelessWidget {
  final ProfileViewModel vm;
  const DangerZoneCard({super.key, required this.vm});

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
          ActionTile(
            icon: Icons.file_download_outlined,
            label: 'Export All Campaigns',
            subtitle: 'Download as PDF / ZIP',
            onTap: vm.exportAllCampaigns,
          ),
          ActionTile(
            icon: Icons.logout,
            label: 'Sign Out',
            onTap: () => _handleSignOut(context),
            color: AppColors.textSecondary,
          ),
          ActionTile(
            icon: Icons.delete_forever_outlined,
            label: 'Delete Account & Data',
            onTap: vm.deleteAccount,
            color: const Color(0xFFD32F2F),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Signing out...', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await vm.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }
}
