import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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

class _GeneratorView extends StatefulWidget {
  const _GeneratorView();

  @override
  State<_GeneratorView> createState() => _GeneratorViewState();
}

class _GeneratorViewState extends State<_GeneratorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _badgeFade;
  late Animation<Offset> _badgeSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _badgeFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _badgeSlide = Tween(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
          ),
        );

    _cardFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GeneratorViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // AI-Powered Marketing badge
                  SlideTransition(
                    position: _badgeSlide,
                    child: FadeTransition(
                      opacity: _badgeFade,
                      child: Container(
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
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Shiksha Suite title
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleFade,
                      child: RichText(
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
                              text: 'Studio',
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
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleFade,
                      child: Text(
                        'Create high-converting marketing campaigns in seconds. Emotional, persuasive, and ready to deploy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form card
                  SlideTransition(
                    position: _cardSlide,
                    child: FadeTransition(
                      opacity: _cardFade,
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Campaign Topic
                            const AppFormLabel('CAMPAIGN TOPIC'),
                            const SizedBox(height: 8),
                            AppTextField(
                              controller: vm.topicController,
                              hint:
                                  'e.g. MBBS in Russia, Study Abroad Scholarship, Coding Bootcamp...',
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
                            AppPhoneField(
                              key: ValueKey(vm.dialCode),
                              controller: vm.phoneController,
                              dialCode: vm.dialCode,
                            ),
                            const SizedBox(height: 20),

                            // Error message
                            if (vm.errorMessage != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFEF9A9A),
                                  ),
                                ),
                                child: Text(
                                  vm.errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFB71C1C),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Generate Campaign button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed:
                                    vm.isGenerating ? null : vm.generate,
                                icon: vm.isGenerating
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
                                  vm.isGenerating
                                      ? 'Generating...'
                                      : 'Generate Campaign',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      AppColors.secondary.withValues(
                                        alpha: 0.7,
                                      ),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campaign Result
                  if (vm.campaign != null)
                    SlideTransition(
                      position: _cardSlide,
                      child: FadeTransition(
                        opacity: _cardFade,
                        child: _CampaignResultCard(
                          campaign: vm.campaign!,
                          onClear: vm.clearCampaign,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CampaignResultCard extends StatelessWidget {
  final Map<String, dynamic> campaign;
  final VoidCallback onClear;

  const _CampaignResultCard({
    required this.campaign,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Generated Campaign',
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

          if (campaign['headline'] != null)
            _ResultSection(
              label: 'HEADLINE',
              content: campaign['headline'] as String,
            ),
          if (campaign['subheadline'] != null)
            _ResultSection(
              label: 'SUBHEADLINE',
              content: campaign['subheadline'] as String,
            ),
          if (campaign['body'] != null)
            _ResultSection(
              label: 'BODY',
              content: campaign['body'] as String,
            ),
          if (campaign['cta'] != null)
            _ResultSection(
              label: 'CALL TO ACTION',
              content: campaign['cta'] as String,
            ),
          if (campaign['whatsapp_message'] != null)
            _ResultSection(
              label: 'WHATSAPP MESSAGE',
              content: campaign['whatsapp_message'] as String,
              copyable: true,
            ),
          if (campaign['sms_text'] != null)
            _ResultSection(
              label: 'SMS TEXT',
              content: campaign['sms_text'] as String,
              copyable: true,
            ),
          if (campaign['key_benefits'] != null)
            _ResultSection(
              label: 'KEY BENEFITS',
              content: (campaign['key_benefits'] as List).join('\n'),
            ),
          if (campaign['hashtags'] != null)
            _ResultSection(
              label: 'HASHTAGS',
              content: (campaign['hashtags'] as List).join('  '),
              copyable: true,
            ),
          if (campaign['target_audience'] != null)
            _ResultSection(
              label: 'TARGET AUDIENCE',
              content: campaign['target_audience'] as String,
            ),

          // Fallback for raw text
          if (campaign['raw_text'] != null)
            _ResultSection(
              label: 'CAMPAIGN',
              content: campaign['raw_text'] as String,
            ),

          const Divider(height: 32),

          // Copy All + Share buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _buildFullText()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Campaign copied!'),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
        ],
      ),
    );
  }

  String _buildFullText() {
    final buffer = StringBuffer();

    void add(String label, dynamic value) {
      if (value == null) return;
      if (value is List) {
        buffer.writeln('$label:');
        for (final item in value) {
          buffer.writeln('  - $item');
        }
      } else {
        buffer.writeln('$label:');
        buffer.writeln(value);
      }
      buffer.writeln();
    }

    add('HEADLINE', campaign['headline']);
    add('SUBHEADLINE', campaign['subheadline']);
    add('BODY', campaign['body']);
    add('CALL TO ACTION', campaign['cta']);
    add('WHATSAPP MESSAGE', campaign['whatsapp_message']);
    add('SMS TEXT', campaign['sms_text']);
    add('KEY BENEFITS', campaign['key_benefits']);
    add('HASHTAGS', campaign['hashtags']);
    add('TARGET AUDIENCE', campaign['target_audience']);
    if (campaign['raw_text'] != null) {
      buffer.writeln(campaign['raw_text']);
    }

    return buffer.toString().trim();
  }
}

class _ResultSection extends StatelessWidget {
  final String label;
  final String content;
  final bool copyable;

  const _ResultSection({
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
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                  letterSpacing: 0.5,
                ),
              ),
              if (copyable) ...[
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // ignore: deprecated_member_use
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
                  child: Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
