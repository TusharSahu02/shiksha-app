import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';

class StatsCard extends StatelessWidget {
  final ProfileViewModel vm;
  const StatsCard({super.key, required this.vm});

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
