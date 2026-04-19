import 'package:flutter/material.dart';
import '../../data/models/image_config.dart';
import '../../data/models/print_material_config.dart';
import '../../data/models/reel_config.dart';
import '../../services/campaign_service.dart';
import '../../services/usage_service.dart';

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
  MarketingStudioViewModel() {
    imageTopicController.addListener(notifyListeners);
    imageInstitutionController.addListener(notifyListeners);
    reelPromptController.addListener(notifyListeners);
  }

  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  PrintMaterialConfig _printConfig = const PrintMaterialConfig();
  PrintMaterialConfig get printConfig => _printConfig;

  ReelConfig _reelConfig = const ReelConfig();
  ReelConfig get reelConfig => _reelConfig;

  ImageConfig _imageConfig = const ImageConfig();
  ImageConfig get imageConfig => _imageConfig;

  // Print material generation state
  bool _isGeneratingPrint = false;
  bool get isGeneratingPrint => _isGeneratingPrint;

  String? _printError;
  String? get printError => _printError;

  Map<String, dynamic>? _printResult;
  Map<String, dynamic>? get printResult => _printResult;

  // Reel generation state
  bool _isGeneratingReel = false;
  bool get isGeneratingReel => _isGeneratingReel;

  String? _reelError;
  String? get reelError => _reelError;

  Map<String, dynamic>? _reelResult;
  Map<String, dynamic>? get reelResult => _reelResult;

  bool get isReelFormValid => reelPromptController.text.trim().isNotEmpty;

  // Image generation state
  bool _isGeneratingImage = false;
  bool get isGeneratingImage => _isGeneratingImage;

  String? _imageError;
  String? get imageError => _imageError;

  Map<String, dynamic>? _imageResult;
  Map<String, dynamic>? get imageResult => _imageResult;

  bool get isImageFormValid =>
      imageTopicController.text.trim().isNotEmpty &&
      imageInstitutionController.text.trim().isNotEmpty;

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

  Future<void> generatePrintMaterial() async {
    if (_isGeneratingPrint) return;

    final topic = topicController.text.trim();
    if (topic.isEmpty) {
      _printError = 'Please enter a topic';
      notifyListeners();
      return;
    }

    _isGeneratingPrint = true;
    _printError = null;
    _printResult = null;
    notifyListeners();

    _printConfig = _printConfig.copyWith(
      topic: topic,
      institution: institutionController.text.trim(),
      tagline: taglineController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      website: websiteController.text.trim(),
      address: addressController.text.trim(),
      keyOfferings: keyOfferingsController.text.trim(),
      usp: uspController.text.trim(),
    );

    try {
      _printResult = await CampaignService.generatePrintMaterial(
        topic: _printConfig.topic,
        materialType: _printConfig.materialType,
        outputLanguage: _printConfig.outputLanguage,
        outputSize: _printConfig.outputSize,
        designStyle: _printConfig.designStyle,
        targetAudience: _printConfig.targetAudience,
        institution: _printConfig.institution,
        tagline: _printConfig.tagline,
        phone: _printConfig.phone,
        email: _printConfig.email,
        website: _printConfig.website,
        address: _printConfig.address,
        keyOfferings: _printConfig.keyOfferings,
        usp: _printConfig.usp,
      );
      UsageService.incrementPrintMaterial();
    } catch (e) {
      debugPrint('=====================================================================================');
      debugPrint('[StudioVM] PRINT ERROR: $e');
      debugPrint('=====================================================================================');
      _printError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isGeneratingPrint = false;
      notifyListeners();
    }
  }

  void clearPrintResult() {
    _printResult = null;
    _printError = null;
    notifyListeners();
  }

  Future<void> generateReel() async {
    if (_isGeneratingReel) return;

    final prompt = reelPromptController.text.trim();
    if (prompt.isEmpty) {
      _reelError = 'Please describe your reel idea';
      notifyListeners();
      return;
    }

    _reelConfig = _reelConfig.copyWith(prompt: prompt);
    _isGeneratingReel = true;
    _reelError = null;
    _reelResult = null;
    notifyListeners();

    try {
      _reelResult = await CampaignService.generateReelScript(
        prompt: prompt,
        reelDuration: _reelConfig.reelDuration,
        reelStyle: _reelConfig.reelStyle,
        musicGenre: _reelConfig.musicGenre,
        targetPlatform: _reelConfig.targetPlatform,
        videoQuality: _reelConfig.videoQuality,
        scriptLanguage: _reelConfig.scriptLanguage,
        includeCaptions: _reelConfig.includeCaptions,
        includeVoiceoverScript: _reelConfig.includeVoiceoverScript,
      );
      UsageService.incrementVideo();
    } catch (e) {
      _reelError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isGeneratingReel = false;
      notifyListeners();
    }
  }

  void clearReelResult() {
    _reelResult = null;
    _reelError = null;
    notifyListeners();
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

  Future<void> generateImage() async {
    if (_isGeneratingImage) return;

    final topic = imageTopicController.text.trim();
    if (topic.isEmpty) {
      _imageError = 'Please enter a topic';
      notifyListeners();
      return;
    }

    _imageConfig = _imageConfig.copyWith(
      topic: topic,
      institution: imageInstitutionController.text.trim(),
      headline: imageHeadlineController.text.trim(),
      subText: imageSubTextController.text.trim(),
    );

    _isGeneratingImage = true;
    _imageError = null;
    _imageResult = null;
    notifyListeners();

    try {
      _imageResult = await CampaignService.generateImage(
        imageType: _imageConfig.imageType,
        topic: _imageConfig.topic,
        institution: _imageConfig.institution,
        aspectRatio: _imageConfig.aspectRatio,
        visualStyle: _imageConfig.visualStyle,
        colorScheme: _imageConfig.colorScheme,
        includeTextOverlay: _imageConfig.includeTextOverlay,
        headline: _imageConfig.headline,
        subText: _imageConfig.subText,
        variantCount: 1,
      );
      UsageService.incrementImage();
    } catch (e) {
      debugPrint('=====================================================================================');
      debugPrint('[StudioVM] IMAGE ERROR: $e');
      debugPrint('=====================================================================================');
      _imageError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isGeneratingImage = false;
      notifyListeners();
    }
  }

  void clearImageResult() {
    _imageResult = null;
    _imageError = null;
    notifyListeners();
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
