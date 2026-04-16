import 'package:flutter/material.dart';
import '../../data/constants/countries.dart';
import '../../data/constants/country_dial_codes.dart';
import '../../data/constants/country_languages.dart';
import '../../data/models/campaign_config.dart';

class GeneratorViewModel extends ChangeNotifier {
  final topicController = TextEditingController();
  final phoneController = TextEditingController();

  CampaignConfig _config = const CampaignConfig();
  CampaignConfig get config => _config;

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

  void generate() {
    _config = _config.copyWith(
      topic: topicController.text,
      phone: phoneController.text,
    );
    // TODO: Trigger campaign generation
  }

  @override
  void dispose() {
    topicController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
