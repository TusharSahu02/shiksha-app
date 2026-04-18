import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/pdf_export_service.dart';
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
              if (vm.selectedTab == 0) ...[
                _PrintMaterialsForm(vm: vm),
                if (vm.printResult != null) ...[
                  const SizedBox(height: 24),
                  _PrintResultCard(
                    material: vm.printResult!,
                    onClear: vm.clearPrintResult,
                  ),
                ],
              ] else if (vm.selectedTab == 1)
                _ReelCreatorForm(vm: vm)
              else if (vm.selectedTab == 2)
                _ImageCreatorForm(vm: vm),
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
              child: Icon(
                currentTab.icon,
                size: 17,
                color: AppColors.secondary,
              ),
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
            items: const ['English', 'Hindi', 'Hinglish', 'Spanish', 'French'],
            onChanged: (val) => vm.updateOutputLanguage(val!),
          ),

          AppDropdownField(
            label: 'OUTPUT SIZE / FORMAT',
            value: vm.printConfig.outputSize,
            items: const [
              'A4 (210×297mm) — Standard',
              'A3 (297×420mm) — Large Format',
              'Letter (8.5×11in) — US Standard',
              'Landscape Banner (1200×628px)',
              'Square (1080×1080px) — Social Media',
              'Story (1080×1920px) — Instagram/WhatsApp',
            ],
            onChanged: (val) => vm.updateOutputSize(val!),
          ),

          AppDropdownField(
            label: 'DESIGN STYLE',
            value: vm.printConfig.designStyle,
            items: const [
              'Professional & Corporate',
              'Vibrant & Colorful',
              'Minimal & Clean',
              'Bold & Impactful',
              'Elegant & Premium',
              'Friendly & Approachable',
            ],
            onChanged: (val) => vm.updateDesignStyle(val!),
          ),

          AppDropdownField(
            label: 'TARGET AUDIENCE',
            value: vm.printConfig.targetAudience,
            items: const [
              'Students (Class 10-12)',
              'College Students',
              'Parents',
              'Working Professionals',
              'Coaching Aspirants',
              'Study Abroad Seekers',
              'Medical/Engineering Aspirants',
              'MBA/Management Seekers',
              'Government Exam Aspirants',
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

          // Error message
          if (vm.printError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEF9A9A)),
              ),
              child: Text(
                vm.printError!,
                style: const TextStyle(fontSize: 13, color: Color(0xFFB71C1C)),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Generate button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: vm.isGeneratingPrint ? null : vm.generatePrintMaterial,
              icon: vm.isGeneratingPrint
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome, size: 18),
              label: Text(
                vm.isGeneratingPrint ? 'Generating...' : 'Generate',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.secondary.withValues(alpha: 0.7),
                disabledForegroundColor: Colors.white70,
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

class _PrintResultCard extends StatelessWidget {
  final Map<String, dynamic> material;
  final VoidCallback onClear;

  const _PrintResultCard({required this.material, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final sections = material['sections'] as List?;
    final highlights = material['key_highlights'] as List?;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Generated Material',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (material['title'] != null)
            _PrintSection(label: 'TITLE', content: material['title'] as String),
          if (material['subtitle'] != null)
            _PrintSection(label: 'SUBTITLE', content: material['subtitle'] as String),

          if (sections != null)
            for (final section in sections)
              if (section is Map<String, dynamic>)
                _PrintSection(
                  label: (section['heading'] as String? ?? '').toUpperCase(),
                  content: section['content'] as String? ?? '',
                ),

          if (highlights != null)
            _PrintSection(
              label: 'KEY HIGHLIGHTS',
              content: highlights.map((h) => '\u2022 $h').join('\n'),
            ),

          if (material['call_to_action'] != null)
            _PrintSection(label: 'CALL TO ACTION', content: material['call_to_action'] as String),
          if (material['contact_block'] != null)
            _PrintSection(label: 'CONTACT', content: material['contact_block'] as String),
          if (material['design_notes'] != null)
            _PrintSection(label: 'DESIGN NOTES', content: material['design_notes'] as String),
          if (material['whatsapp_message'] != null)
            _PrintSection(
              label: 'WHATSAPP MESSAGE',
              content: material['whatsapp_message'] as String,
              copyable: true,
            ),
          if (material['footer_text'] != null)
            _PrintSection(label: 'FOOTER', content: material['footer_text'] as String),
          if (material['raw_text'] != null)
            _PrintSection(label: 'CONTENT', content: material['raw_text'] as String),

          const Divider(height: 32),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _buildFullText()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Material copied!'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text(
                      'Copy All',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: BorderSide(color: AppColors.secondary),
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
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final box = context.findRenderObject() as RenderBox?;
                      await SharePlus.instance.share(
                        ShareParams(
                          text: _buildFullText(),
                          sharePositionOrigin: box != null
                              ? box.localToGlobal(Offset.zero) & box.size
                              : null,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text(
                      'Share',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => PdfExportService.exportPrintMaterial(material),
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text(
                'Download PDF',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                side: BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildFullText() {
    final buffer = StringBuffer();

    if (material['title'] != null) {
      buffer.writeln(material['title']);
      buffer.writeln();
    }
    if (material['subtitle'] != null) {
      buffer.writeln(material['subtitle']);
      buffer.writeln();
    }

    final sections = material['sections'] as List?;
    if (sections != null) {
      for (final section in sections) {
        if (section is Map<String, dynamic>) {
          buffer.writeln('--- ${section['heading'] ?? ''} ---');
          buffer.writeln(section['content'] ?? '');
          buffer.writeln();
        }
      }
    }

    final highlights = material['key_highlights'] as List?;
    if (highlights != null) {
      buffer.writeln('KEY HIGHLIGHTS:');
      for (final h in highlights) {
        buffer.writeln('\u2022 $h');
      }
      buffer.writeln();
    }

    if (material['call_to_action'] != null) {
      buffer.writeln('CTA: ${material['call_to_action']}');
      buffer.writeln();
    }
    if (material['contact_block'] != null) {
      buffer.writeln('CONTACT: ${material['contact_block']}');
      buffer.writeln();
    }
    if (material['whatsapp_message'] != null) {
      buffer.writeln('WHATSAPP: ${material['whatsapp_message']}');
    }
    if (material['raw_text'] != null) {
      buffer.writeln(material['raw_text']);
    }

    return buffer.toString().trim();
  }
}

class _PrintSection extends StatelessWidget {
  final String label;
  final String content;
  final bool copyable;

  const _PrintSection({
    required this.label,
    required this.content,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: content));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$label copied!'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.copy, size: 16, color: AppColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelCreatorForm extends StatelessWidget {
  final MarketingStudioViewModel vm;

  const _ReelCreatorForm({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.videocam_outlined,
                size: 20,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Reel Script & Creator',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Describe your reel idea — AI generates a complete HD production-ready script with music, scenes, and effects',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Reel Prompt
          const AppFormLabel('YOUR REEL IDEA / PROMPT *'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.reelPromptController,
            hint:
                'Describe your reel in detail...\n\nExamples:\n\u2022 \'A reel showing the transformation of a NEET student who struggled for 2 years and finally cracked the exam after joining our coaching\'\n\u2022 \'Showcase MBBS life in Russia — hostels, university, snow, Indian food, success stories\'',
            maxLines: 6,
          ),
          const SizedBox(height: 16),

          // Reel Duration
          AppDropdownField(
            label: 'REEL DURATION',
            value: vm.reelConfig.reelDuration,
            items: const [
              '15 seconds — Quick Hook',
              '30 seconds — Standard Reel',
              '60 seconds — Detailed Reel',
              '90 seconds — Extended Story',
            ],
            onChanged: (val) => vm.updateReelDuration(val!),
          ),

          // Reel Style
          AppDropdownField(
            label: 'REEL STYLE',
            value: vm.reelConfig.reelStyle,
            items: const [
              'Cinematic & Emotional',
              'Fast-Paced & Energetic',
              'Storytelling & Narrative',
              'Informational & Educational',
              'Testimonial & Social Proof',
              'Before & After Transformation',
            ],
            onChanged: (val) => vm.updateReelStyle(val!),
          ),

          // Background Music Genre
          AppDropdownField(
            label: '\u{1F3B5} BACKGROUND MUSIC GENRE',
            value: vm.reelConfig.musicGenre,
            items: const [
              'Inspirational / Motivational',
              'Upbeat & Energetic',
              'Calm & Ambient',
              'Dramatic & Cinematic',
              'Trending / Viral Audio',
              'No Music',
            ],
            onChanged: (val) => vm.updateMusicGenre(val!),
          ),

          // Target Platform
          AppDropdownField(
            label: 'TARGET PLATFORM',
            value: vm.reelConfig.targetPlatform,
            items: const [
              'Instagram Reels',
              'YouTube Shorts',
              'TikTok',
              'Facebook Reels',
              'LinkedIn Video',
            ],
            onChanged: (val) => vm.updateTargetPlatform(val!),
          ),

          // Video Quality / Resolution
          AppDropdownField(
            label: '\u{1F3AC} VIDEO QUALITY / RESOLUTION',
            value: vm.reelConfig.videoQuality,
            items: const [
              '1080p HD (1080×1920)',
              '720p (720×1280)',
              '4K (2160×3840)',
            ],
            onChanged: (val) => vm.updateVideoQuality(val!),
          ),

          // Script Language
          AppDropdownField(
            label: 'SCRIPT LANGUAGE',
            value: vm.reelConfig.scriptLanguage,
            items: const [
              'English',
              'Hindi',
              'Hinglish',
              'Spanish',
              'French',
              'Arabic',
            ],
            onChanged: (val) => vm.updateScriptLanguage(val!),
          ),

          // Toggle chips: Include Captions & Include Voiceover Script
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ToggleChip(
                    icon: Icons.subtitles_outlined,
                    label: 'Include Captions',
                    subtitle: 'On-screen text overlays',
                    isActive: vm.reelConfig.includeCaptions,
                    onTap: () =>
                        vm.toggleCaptions(!vm.reelConfig.includeCaptions),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ToggleChip(
                    icon: Icons.record_voice_over_outlined,
                    label: 'Include Voiceover Script',
                    subtitle: 'Full narration script',
                    isActive: vm.reelConfig.includeVoiceoverScript,
                    onTap: () => vm.toggleVoiceoverScript(
                      !vm.reelConfig.includeVoiceoverScript,
                    ),
                  ),
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
              onPressed: vm.generateReel,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text(
                'Generate Complete Reel Script',
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

class _ToggleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.secondary.withValues(alpha: 0.4)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.secondary : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.secondary : AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageCreatorForm extends StatelessWidget {
  final MarketingStudioViewModel vm;

  const _ImageCreatorForm({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.image_outlined, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'AI Marketing Image Creator',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Generate professional marketing visuals for posters, banners, social media & more',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Image Type
          AppDropdownField(
            label: 'IMAGE TYPE',
            value: vm.imageConfig.imageType,
            items: const [
              'Admission Poster',
              'Scholarship Banner',
              'Campus Life Visual',
              'Student Success Story',
              'Course Feature Card',
              'Faculty Highlight',
              'Event Banner',
              'Testimonial Card',
              'Motivational Poster',
              'Infographic',
              'Social Media Post',
              'WhatsApp Status / DP',
              'Custom (Describe Below)',
            ],
            onChanged: (val) => vm.updateImageType(val!),
          ),

          // Topic & Institution side by side
          const AppFormLabel('TOPIC / COURSE / SUBJECT'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.imageTopicController,
            hint: 'e.g. NEET 2025, MBBS Abroad, Study UK',
          ),
          const SizedBox(height: 16),

          const AppFormLabel('INSTITUTION / BRAND NAME'),
          const SizedBox(height: 8),
          AppTextField(
            controller: vm.imageInstitutionController,
            hint: 'e.g. ABC Academy',
          ),
          const SizedBox(height: 16),

          // Aspect Ratio
          AppDropdownField(
            label: 'ASPECT RATIO / SIZE',
            value: vm.imageConfig.aspectRatio,
            items: const [
              '1:1 Square (Instagram Post / Profile)',
              '4:5 Portrait (Instagram Feed)',
              '9:16 Story (Instagram / WhatsApp / Reels)',
              '16:9 Landscape (YouTube / Facebook)',
              '3:1 Wide Banner (Website / Print)',
              'A4 Portrait (Print Ready)',
            ],
            onChanged: (val) => vm.updateAspectRatio(val!),
          ),

          // Visual Style
          AppDropdownField(
            label: 'VISUAL STYLE',
            value: vm.imageConfig.visualStyle,
            items: const [
              'Photorealistic',
              'Modern Flat Design',
              'Watercolor Illustration',
              '3D Rendered',
              'Bold Typography Poster',
              'Gradient & Neon',
              'Corporate Professional',
              'Warm & Friendly',
              'Cinematic Dark',
              'Bright & Vibrant',
            ],
            onChanged: (val) => vm.updateVisualStyle(val!),
          ),

          // Color Scheme
          const AppFormLabel('COLOR SCHEME'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ColorSchemeData('Orange & White (Brand Colors)', Color(0xFFF0A030), Colors.white),
              _ColorSchemeData('Navy Blue & Gold', Color(0xFF1B2A4A), Color(0xFFD4A017)),
              _ColorSchemeData('Green & White', Color(0xFF2E7D32), Colors.white),
              _ColorSchemeData('Purple & Silver', Color(0xFF6A1B9A), Color(0xFFC0C0C0)),
              _ColorSchemeData('Red & White', Color(0xFFD32F2F), Colors.white),
              _ColorSchemeData('Teal & Orange', Color(0xFF00897B), Color(0xFFF0A030)),
              _ColorSchemeData('Black & Gold (Premium)', Color(0xFF212121), Color(0xFFD4A017)),
              _ColorSchemeData('Pastel Soft Tones', Color(0xFFB39DDB), Color(0xFFF8BBD0)),
            ].map((data) {
              return _ColorSchemeChip(
                label: data.label,
                color1: data.color1,
                color2: data.color2,
                isSelected: vm.imageConfig.colorScheme == data.label,
                onTap: () => vm.updateColorScheme(data.label),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Include Text Overlay toggle
          Row(
            children: [
              Switch(
                value: vm.imageConfig.includeTextOverlay,
                onChanged: vm.toggleTextOverlay,
                activeTrackColor: AppColors.secondary,
                activeThumbColor: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                'Include Text Overlay in Image',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),

          // Headline & Sub Text (shown when text overlay is on)
          if (vm.imageConfig.includeTextOverlay) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: vm.imageHeadlineController,
                    hint: 'Main Headline (e.g. Admissions Open 2025)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: vm.imageSubTextController,
                    hint: 'Sub Text (e.g. Limited Seats Available)',
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),

          // Number of variants
          const AppFormLabel('NUMBER OF VARIANTS TO GENERATE'),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final count in [1, 2, 3]) ...[
                if (count > 1) const SizedBox(width: 10),
                Expanded(
                  child: _VariantChip(
                    label: '$count Image${count > 1 ? 's' : ''}',
                    isActive: vm.imageConfig.variantCount == count,
                    onTap: () => vm.updateVariantCount(count),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Generate button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: vm.generateImage,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: Text(
                'Generate ${vm.imageConfig.variantCount} AI Marketing Image${vm.imageConfig.variantCount > 1 ? 's' : ''}',
                style: const TextStyle(
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
    );
  }
}

class _VariantChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _VariantChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.secondary : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.secondary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorSchemeData {
  final String label;
  final Color color1;
  final Color color2;

  const _ColorSchemeData(this.label, this.color1, this.color2);
}

class _ColorSchemeChip extends StatelessWidget {
  final String label;
  final Color color1;
  final Color color2;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSchemeChip({
    required this.label,
    required this.color1,
    required this.color2,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Diagonal two-tone square
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomPaint(
                size: const Size(28, 28),
                painter: _DiagonalColorPainter(color1, color2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.secondary
                    : AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagonalColorPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  _DiagonalColorPainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;

    // Bottom-left triangle (color1)
    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, paint1);

    // Top-right triangle (color2)
    final path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path2, paint2);

    // Border for white colors
    final borderPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRect(Offset.zero & size, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _DiagonalColorPainter oldDelegate) =>
      color1 != oldDelegate.color1 || color2 != oldDelegate.color2;
}
