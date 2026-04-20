import 'package:flutter/material.dart';
import '../../data/constants/countries.dart';
import '../../data/constants/country_dial_codes.dart';
import '../../data/constants/country_languages.dart';
import '../../data/models/campaign_config.dart';
import '../../services/campaign_service.dart';
import '../../services/history_service.dart';
import '../../services/usage_service.dart';

class GeneratorViewModel extends ChangeNotifier {
  final topicController = TextEditingController();
  final phoneController = TextEditingController();

  GeneratorViewModel() {
    topicController.addListener(notifyListeners);
    phoneController.addListener(notifyListeners);
  }

  CampaignConfig _config = const CampaignConfig();
  CampaignConfig get config => _config;

  bool get isFormValid =>
      topicController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty;

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _campaign;
  Map<String, dynamic>? get campaign => _campaign;

  final List<String> countries = kCountries;

  List<String> get languages =>
      kCountryLanguages[_config.country] ?? const ['English'];

  String get dialCode =>
      kCountryDialCodes[_config.country] ?? '+1';

  void updateCountry(String country) {
    final langs = kCountryLanguages[country] ?? const ['English'];
    _config = _config.copyWith(country: country, language: langs.first);
    notifyListeners();
  }

  void updateLanguage(String language) {
    _config = _config.copyWith(language: language);
    notifyListeners();
  }

  Future<void> generate() async {
    if (_isGenerating) {
      debugPrint('=====================================================================================');
      debugPrint('[GeneratorVM] Already generating, ignoring tap');
      debugPrint('=====================================================================================');
      return;
    }

    final topic = topicController.text.trim();
    if (topic.isEmpty) {
      _errorMessage = 'Please enter a campaign topic';
      notifyListeners();
      return;
    }

    _isGenerating = true;
    _errorMessage = null;
    _campaign = null;
    notifyListeners();

    debugPrint('=====================================================================================');
    debugPrint('[GeneratorVM] Starting generation: topic="$topic", country="${_config.country}"');
    debugPrint('=====================================================================================');

    try {
      final fullPhone = phoneController.text.trim().isNotEmpty
          ? '$dialCode${phoneController.text.trim()}'
          : '';

      _campaign = await CampaignService.generateCampaign(
        topic: topic,
        country: _config.country,
        language: _config.language,
        phone: fullPhone,
      );
      UsageService.incrementCampaign();
      HistoryService.save(
        type: 'text',
        topic: topic,
        country: _config.country,
        language: _config.language,
        output: _campaign!,
      );
    } catch (e) {
      debugPrint('=====================================================================================');
      debugPrint('[GeneratorVM] GENERATE ERROR: $e');
      debugPrint('=====================================================================================');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  void clearCampaign() {
    _campaign = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    topicController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
