import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import 'profile_view_model.dart';
import 'widgets/profile_card.dart';
import 'widgets/subscription_card.dart';
import 'widgets/stats_card.dart';
import 'widgets/account_info_card.dart';
import 'widgets/brand_kit_card.dart';
import 'widgets/preferences_card.dart';
import 'widgets/help_card.dart';
import 'widgets/danger_zone_card.dart';
import 'widgets/profile_skeleton.dart';

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
      body: vm.isLoading
          ? const ProfileSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileCard(vm: vm),
                  const SizedBox(height: 16),
                  SubscriptionCard(vm: vm),
                  const SizedBox(height: 16),
                  StatsCard(vm: vm),
                  const SizedBox(height: 16),
                  AccountInfoCard(vm: vm),
                  const SizedBox(height: 16),
                  BrandKitCard(vm: vm),
                  const SizedBox(height: 16),
                  PreferencesCard(vm: vm),
                  const SizedBox(height: 16),
                  const HelpCard(),
                  const SizedBox(height: 16),
                  DangerZoneCard(vm: vm),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
