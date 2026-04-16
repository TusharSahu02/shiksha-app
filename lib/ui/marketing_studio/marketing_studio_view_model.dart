import 'package:flutter/material.dart';
import '../../data/models/image_config.dart';
import '../../data/models/print_material_config.dart';
import '../../data/models/reel_config.dart';

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

  ReelConfig _reelConfig = const ReelConfig();
  ReelConfig get reelConfig => _reelConfig;

  ImageConfig _imageConfig = const ImageConfig();
  ImageConfig get imageConfig => _imageConfig;

  // Print material controllers
  final topicController = TextEditingController();
  final institutionController = TextEditingController();
  final taglineController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();
  final keyOfferingsController = TextEditingController();
  final uspController = TextEditingController();

  // Reel creator controllers
  final reelPromptController = TextEditingController();

  // Image creator controllers
  final imageTopicController = TextEditingController();
  final imageInstitutionController = TextEditingController();
  final imageHeadlineController = TextEditingController();
  final imageSubTextController = TextEditingController();

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

  // Reel config updaters
  void updateReelDuration(String value) {
    _reelConfig = _reelConfig.copyWith(reelDuration: value);
    notifyListeners();
  }

  void updateReelStyle(String value) {
    _reelConfig = _reelConfig.copyWith(reelStyle: value);
    notifyListeners();
  }

  void updateMusicGenre(String value) {
    _reelConfig = _reelConfig.copyWith(musicGenre: value);
    notifyListeners();
  }

  void updateTargetPlatform(String value) {
    _reelConfig = _reelConfig.copyWith(targetPlatform: value);
    notifyListeners();
  }

  void updateVideoQuality(String value) {
    _reelConfig = _reelConfig.copyWith(videoQuality: value);
    notifyListeners();
  }

  void updateScriptLanguage(String value) {
    _reelConfig = _reelConfig.copyWith(scriptLanguage: value);
    notifyListeners();
  }

  void toggleCaptions(bool value) {
    _reelConfig = _reelConfig.copyWith(includeCaptions: value);
    notifyListeners();
  }

  void toggleVoiceoverScript(bool value) {
    _reelConfig = _reelConfig.copyWith(includeVoiceoverScript: value);
    notifyListeners();
  }

  void generatePrintMaterial() {
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

  void generateReel() {
    _reelConfig = _reelConfig.copyWith(
      prompt: reelPromptController.text,
    );
    // TODO: Trigger reel generation
  }

  // Image config updaters
  void updateImageType(String value) {
    _imageConfig = _imageConfig.copyWith(imageType: value);
    notifyListeners();
  }

  void updateAspectRatio(String value) {
    _imageConfig = _imageConfig.copyWith(aspectRatio: value);
    notifyListeners();
  }

  void updateVisualStyle(String value) {
    _imageConfig = _imageConfig.copyWith(visualStyle: value);
    notifyListeners();
  }

  void updateColorScheme(String value) {
    _imageConfig = _imageConfig.copyWith(colorScheme: value);
    notifyListeners();
  }

  void toggleTextOverlay(bool value) {
    _imageConfig = _imageConfig.copyWith(includeTextOverlay: value);
    notifyListeners();
  }

  void updateVariantCount(int count) {
    _imageConfig = _imageConfig.copyWith(variantCount: count);
    notifyListeners();
  }

  void generateImage() {
    _imageConfig = _imageConfig.copyWith(
      topic: imageTopicController.text,
      institution: imageInstitutionController.text,
      headline: imageHeadlineController.text,
      subText: imageSubTextController.text,
    );
    // TODO: Trigger image generation
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
    reelPromptController.dispose();
    imageTopicController.dispose();
    imageInstitutionController.dispose();
    imageHeadlineController.dispose();
    imageSubTextController.dispose();
    super.dispose();
  }
}
