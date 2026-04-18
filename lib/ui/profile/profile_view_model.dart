import 'package:flutter/material.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/subscription_tier.dart';
import '../../services/auth_service.dart';
import '../auth/auth_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  // Account
  final phoneController = TextEditingController(text: '+91 98765 43210');
  final verifyPhoneController = TextEditingController(text: '+91 98765 43210');

  // Brand Kit
  final institutionController = TextEditingController();
  final taglineController = TextEditingController();
  final institutionEmailController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();
  final keyOfferingsController = TextEditingController();
  final uspController = TextEditingController();

  UserProfile _profile = UserProfile(
    tier: SubscriptionTier.silver,
    renewalDate: DateTime(2025, 7, 15),
    usedImages: 64,
    usedVideos: 18,
    totalCampaigns: 24,
    totalImages: 47,
    totalVideos: 8,
    totalPrintMaterials: 12,
  );
  UserProfile get profile => _profile;

  void saveAccountChanges() {
    _profile = _profile.copyWith(phone: phoneController.text);
    notifyListeners();
  }

  void saveBrandKit() {
    _profile = _profile.copyWith(
      institutionName: institutionController.text,
      tagline: taglineController.text,
      institutionEmail: institutionEmailController.text,
      website: websiteController.text,
      address: addressController.text,
      keyOfferings: keyOfferingsController.text,
      usp: uspController.text,
    );
    notifyListeners();
  }

  void updateDefaultCountry(String value) {
    _profile = _profile.copyWith(defaultCountry: value);
    notifyListeners();
  }

  void updateDefaultLanguage(String value) {
    _profile = _profile.copyWith(defaultLanguage: value);
    notifyListeners();
  }

  void updateDefaultAudience(String value) {
    _profile = _profile.copyWith(defaultAudience: value);
    notifyListeners();
  }

  void updateDefaultPlatform(String value) {
    _profile = _profile.copyWith(defaultPlatform: value);
    notifyListeners();
  }

  void toggleNotifyOnComplete(bool value) {
    _profile = _profile.copyWith(notifyOnComplete: value);
    notifyListeners();
  }

  void toggleNotifyWeeklySummary(bool value) {
    _profile = _profile.copyWith(notifyWeeklySummary: value);
    notifyListeners();
  }

  void toggleNotifyNewFeatures(bool value) {
    _profile = _profile.copyWith(notifyNewFeatures: value);
    notifyListeners();
  }

  void toggleNotifyRenewal(bool value) {
    _profile = _profile.copyWith(notifyRenewal: value);
    notifyListeners();
  }

  void sendOtp() {
    // TODO: Send OTP via email
  }

  void exportAllCampaigns() {
    // TODO: Export campaigns as PDF/ZIP
  }

  void changePassword() {
    // TODO: Navigate to change password
  }

  Future<void> signOut(BuildContext context) async {
    await AuthService.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  void deleteAccount() {
    // TODO: Delete account
  }

  @override
  void dispose() {
    phoneController.dispose();
    verifyPhoneController.dispose();
    institutionController.dispose();
    taglineController.dispose();
    institutionEmailController.dispose();
    websiteController.dispose();
    addressController.dispose();
    keyOfferingsController.dispose();
    uspController.dispose();
    super.dispose();
  }
}
