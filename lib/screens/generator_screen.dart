import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _topicController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCountry = 'India';
  String _selectedLanguage = 'Hinglish';

  final List<String> _countries = [
    'India',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Russia',
    'Germany',
    'UAE',
  ];

  final List<String> _languages = [
    'Hinglish',
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Arabic',
  ];

  @override
  void dispose() {
    _topicController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 20),

              // AI-Powered Marketing badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondary.withValues(alpha: 0.08),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.secondary),
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
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campaign Topic
                    _buildLabel('CAMPAIGN TOPIC'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _topicController,
                      decoration: _inputDecoration(
                        'e.g. MBBS in Russia, Study Abroad Scholarship, Coding Bootcamp...',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Target Country & Language row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('TARGET COUNTRY'),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: _selectedCountry,
                                items: _countries,
                                onChanged: (val) =>
                                    setState(() => _selectedCountry = val!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('LANGUAGE / STYLE'),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: _selectedLanguage,
                                items: _languages,
                                onChanged: (val) =>
                                    setState(() => _selectedLanguage = val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Phone / WhatsApp Number
                    _buildLabel('PHONE / WHATSAPP NUMBER'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration('+91 98765 43210'),
                    ),
                    const SizedBox(height: 28),

                    // Generate Campaign button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Generate campaign
                        },
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text(
                          'Generate Campaign',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary.withValues(alpha: 0.6),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          style: TextStyle(fontSize: 14, color: AppColors.primaryDark),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
