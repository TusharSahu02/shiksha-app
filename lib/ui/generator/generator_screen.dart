import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../core/widgets/app_form_field.dart';
import 'generator_view_model.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GeneratorViewModel(),
      child: const _GeneratorView(),
    );
  }
}

class _GeneratorView extends StatelessWidget {
  const _GeneratorView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GeneratorViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // AI-Powered Marketing badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary.withValues(alpha: 0.08),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI-Powered Marketing',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shiksha Suite title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Shiksha ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'Suite',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Create high-converting marketing campaigns in seconds. Emotional, persuasive, and ready to deploy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Form card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campaign Topic
                    const AppFormLabel('CAMPAIGN TOPIC'),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: vm.topicController,
                      hint: 'e.g. MBBS in Russia, Study Abroad Scholarship, Coding Bootcamp...',
                    ),
                    const SizedBox(height: 16),

                    // Target Country
                    AppDropdownField(
                      label: 'TARGET COUNTRY',
                      value: vm.config.country,
                      items: vm.countries,
                      onChanged: (val) => vm.updateCountry(val!),
                    ),

                    // Language / Style
                    AppDropdownField(
                      label: 'LANGUAGE / STYLE',
                      value: vm.config.language,
                      items: vm.languages,
                      onChanged: (val) => vm.updateLanguage(val!),
                    ),

                    // Phone / WhatsApp Number
                    const AppFormLabel('PHONE / WHATSAPP NUMBER'),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: vm.phoneController,
                      hint: '+91 98765 43210',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Generate Campaign button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: vm.generate,
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text(
                          'Generate Campaign',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
