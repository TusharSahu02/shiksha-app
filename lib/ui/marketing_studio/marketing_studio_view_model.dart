import 'package:flutter/material.dart';
import '../../data/models/print_material_config.dart';

class TabItem {
  final IconData icon;
  final String label;
  final String description;

  const TabItem({
    required this.icon,
    required this.label,
    required this.description,
  });
}

class MarketingStudioViewModel extends ChangeNotifier {
  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  PrintMaterialConfig _printConfig = const PrintMaterialConfig();
  PrintMaterialConfig get printConfig => _printConfig;

  final topicController = TextEditingController();
  final institutionController = TextEditingController();
  final taglineController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();
  final keyOfferingsController = TextEditingController(
    text:
        'MBBS in Russia\nMBBS in Kazakhstan\nMBBS in Philippines\nNEET Coaching',
  );
  final uspController = TextEditingController(
    text:
        'e.g. 15+ years of experience\n500+ students placed globally\nEnd-to-end visa support',
  );

  final List<TabItem> tabs = const [
    TabItem(
      icon: Icons.description_outlined,
      label: 'Print Materials',
      description: 'Create brochures, flyers & posters',
    ),
    TabItem(
      icon: Icons.videocam_outlined,
      label: 'Reel Creator',
      description: 'Generate video scripts & reels',
    ),
    TabItem(
      icon: Icons.image_outlined,
      label: 'AI Image Creator',
      description: 'Design banners & social media images',
    ),
  ];

  void selectTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void updateMaterialType(String value) {
    _printConfig = _printConfig.copyWith(materialType: value);
    notifyListeners();
  }

  void updateOutputLanguage(String value) {
    _printConfig = _printConfig.copyWith(outputLanguage: value);
    notifyListeners();
  }

  void updateOutputSize(String value) {
    _printConfig = _printConfig.copyWith(outputSize: value);
    notifyListeners();
  }

  void updateDesignStyle(String value) {
    _printConfig = _printConfig.copyWith(designStyle: value);
    notifyListeners();
  }

  void updateTargetAudience(String value) {
    _printConfig = _printConfig.copyWith(targetAudience: value);
    notifyListeners();
  }

  void toggleInternetResearch(bool value) {
    _printConfig = _printConfig.copyWith(useInternetResearch: value);
    notifyListeners();
  }

  void generate() {
    _printConfig = _printConfig.copyWith(
      topic: topicController.text,
      institution: institutionController.text,
      tagline: taglineController.text,
      phone: phoneController.text,
      email: emailController.text,
      website: websiteController.text,
      address: addressController.text,
      keyOfferings: keyOfferingsController.text,
      usp: uspController.text,
    );
    // TODO: Trigger material generation
  }

  @override
  void dispose() {
    topicController.dispose();
    institutionController.dispose();
    taglineController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    addressController.dispose();
    keyOfferingsController.dispose();
    uspController.dispose();
    super.dispose();
  }
}
