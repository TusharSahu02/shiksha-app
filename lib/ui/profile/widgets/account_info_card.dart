import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';
import 'shared_widgets.dart';

class AccountInfoCard extends StatelessWidget {
  final ProfileViewModel vm;
  const AccountInfoCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: Icons.person_outline, title: 'Account Info'),
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
