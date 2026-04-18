import 'package:flutter/material.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/subscription_tier.dart';
import '../../services/auth_service.dart';
import '../auth/auth_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  // Account
  final phoneController = TextEditingController();
  final verifyPhoneController = TextEditingController();

  // Brand Kit
  final institutionController = TextEditingController();
  final taglineController = TextEditingController();
  final institutionEmailController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();
  final keyOfferingsController = TextEditingController();
  final uspController = TextEditingController();

  late UserProfile _profile;
  UserProfile get profile => _profile;

  ProfileViewModel() {
    final user = AuthService.currentUser;
    final meta = user?.userMetadata;
    _profile = UserProfile(
      name: meta?['full_name'] as String? ??
          meta?['name'] as String? ??
          user?.email?.split('@').first ??
          '',
      email: user?.email ?? '',
      photoUrl: meta?['avatar_url'] as String? ??
          meta?['picture'] as String? ??
          '',
      phone: user?.phone ?? '',
      tier: SubscriptionTier.free,
    );
    phoneController.text = _profile.phone;
  }

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFD32F2F)),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Signing out...', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

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
