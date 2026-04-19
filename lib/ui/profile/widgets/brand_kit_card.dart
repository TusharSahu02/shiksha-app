import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../core/widgets/app_form_field.dart';
import '../profile_view_model.dart';
import 'shared_widgets.dart';

class BrandKitCard extends StatelessWidget {
  final ProfileViewModel vm;
  const BrandKitCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
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
