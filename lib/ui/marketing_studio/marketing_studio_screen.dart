import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../core/widgets/app_form_field.dart';
import 'marketing_studio_view_model.dart';

class MarketingStudioScreen extends StatelessWidget {
  const MarketingStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarketingStudioViewModel(),
      child: const _MarketingStudioView(),
    );
  }
}

class _MarketingStudioView extends StatelessWidget {
  const _MarketingStudioView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MarketingStudioViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Marketing ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    TextSpan(
                      text: 'Studio',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'AI-powered brochures, banners & reels — export as PDF, HD Image, or full production script',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Dropdown selector
              _ToolSelector(vm: vm),
              const SizedBox(height: 24),

              // Content area
              if (vm.selectedTab == 0)
                _PrintMaterialsForm(vm: vm)
              else
                _PlaceholderCard(tab: vm.tabs[vm.selectedTab]),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolSelector extends StatelessWidget {
  final MarketingStudioViewModel vm;

  const _ToolSelector({required this.vm});

  @override
  Widget build(BuildContext context) {
    final currentTab = vm.tabs[vm.selectedTab];

    return GestureDetector(
      onTap: () => _showDropdown(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(currentTab.icon, size: 17, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTab.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    currentTab.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Select Tool',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(vm.tabs.length, (index) {
                final tab = vm.tabs[index];
                final isSelected = vm.selectedTab == index;
                return InkWell(
                  onTap: () {
                    vm.selectTab(index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondary.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondary.withValues(alpha: 0.4)
                            : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary.withValues(alpha: 0.15)
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            tab.icon,
                            size: 20,
                            color: isSelected
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tab.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppColors.secondary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }
}

class _PrintMaterialsForm extends StatelessWidget {
  final MarketingStudioViewModel vm;

  const _PrintMaterialsForm({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure Your Marketing Material',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 20),

          AppDropdownField(
            label: 'MATERIAL TYPE',
            value: vm.printConfig.materialType,
            items: const [
              'Tri-fold Brochure',
              'Flyer',
              'Poster',
              'Pamphlet',
              'Banner',
            ],
            onChanged: (val) => vm.updateMaterialType(val!),
          ),
          Text(
            '8-section professional brochure for institutions',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          AppDropdownField(
            label: 'OUTPUT LANGUAGE',
            value: vm.printConfig.outputLanguage,
            items: const [
              'English',
              'Hindi',
              'Hinglish',
              'Spanish',
              'French',
            ],
            onChanged: (val) => vm.updateOutputLanguage(val!),
          ),

          AppDropdownField(
            label: 'OUTPUT SIZE / FORMAT',
            value: vm.printConfig.outputSize,
            items: const [
              'A4 (210×297mm) — Standard',
              'A3 (297×420mm) — Large',
              'Letter (8.5×11in)',
              'A5 (148×210mm) — Compact',
            ],
            onChanged: (val) => vm.updateOutputSize(val!),
          ),

          AppDropdownField(
            label: 'DESIGN STYLE',
            value: vm.printConfig.designStyle,
            items: const [
              'Professional & Corporate',
              'Modern & Minimal',
              'Bold & Colorful',
              'Elegant & Classic',
            ],
            onChanged: (val) => vm.updateDesignStyle(val!),
          ),

          AppDropdownField(
            label: 'TARGET AUDIENCE',
            value: vm.printConfig.targetAudience,
            items: const [
              'Students (Class 10-12)',
              'Parents',
              'College Students',
              'Working Professionals',
              'General Public',
            ],
            onChanged: (val) => vm.updateTargetAudience(val!),
          ),

          const AppFormLabel('TOPIC / COURSE / PROGRAM *'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.topicController,
            hint: 'e.g. MBBS in Russia 2025, NEET Coaching...',
          ),
          const SizedBox(height: 16),

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

          const AppFormLabel('PHONE / WHATSAPP'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.phoneController,
            hint: '+91 98765 43210',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          const AppFormLabel('EMAIL'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.emailController,
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

          const AppFormLabel('KEY OFFERINGS / COURSES (ONE PER LINE)'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.keyOfferingsController,
            hint: 'MBBS in Russia\nMBBS in Kazakhstan\nNEET Coaching',
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          const AppFormLabel('UNIQUE SELLING POINTS / WHY CHOOSE US'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.uspController,
            hint: 'e.g. 15+ years of experience\n500+ students placed globally',
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Internet Research toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.language, size: 20, color: AppColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Internet Research',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        'AI will search genuine data from official sources',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: vm.printConfig.useInternetResearch,
                  onChanged: vm.toggleInternetResearch,
                  activeTrackColor: AppColors.secondary,
                  activeThumbColor: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Generate button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: vm.generate,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text(
                'Generate Tri-fold Brochure',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

class _PlaceholderCard extends StatelessWidget {
  final TabItem tab;

  const _PlaceholderCard({required this.tab});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 44),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(tab.icon, size: 26, color: AppColors.secondary),
            ),
            const SizedBox(height: 14),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tab.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
