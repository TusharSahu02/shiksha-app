import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';
import 'shared_widgets.dart';

class PreferencesCard extends StatelessWidget {
  final ProfileViewModel vm;
  const PreferencesCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: Icons.tune, title: 'Default Preferences'),
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
              'India', 'USA', 'UK', 'Canada',
              'Australia', 'UAE', 'Germany', 'Russia',
            ],
            onChanged: (val) => vm.updateDefaultCountry(val!),
          ),

          AppDropdownField(
            label: 'DEFAULT LANGUAGE',
            value: vm.profile.defaultLanguage,
            items: const [
              'Hinglish', 'English', 'Hindi',
              'Spanish', 'French', 'Arabic',
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
