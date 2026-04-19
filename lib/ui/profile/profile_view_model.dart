import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/constants/country_dial_codes.dart';
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

  late String dialCode;

  String _detectDialCodeFromLocale() {
    final countryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode
            ?.toUpperCase() ??
        '';
    const isoToCountry = {
      'IN': 'India',
      'US': 'United States',
      'GB': 'United Kingdom',
      'AU': 'Australia',
      'CA': 'Canada',
      'AE': 'United Arab Emirates',
      'PK': 'Pakistan',
      'BD': 'Bangladesh',
      'NP': 'Nepal',
      'LK': 'Sri Lanka',
      'DE': 'Germany',
      'FR': 'France',
      'SG': 'Singapore',
      'MY': 'Malaysia',
      'NG': 'Nigeria',
      'ZA': 'South Africa',
      'KE': 'Kenya',
      'PH': 'Philippines',
      'ID': 'Indonesia',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'RU': 'Russia',
      'CN': 'China',
      'JP': 'Japan',
      'KR': 'South Korea',
      'SA': 'Saudi Arabia',
      'QA': 'Qatar',
      'KW': 'Kuwait',
      'BH': 'Bahrain',
      'OM': 'Oman',
      'EG': 'Egypt',
      'TR': 'Turkey',
      'IT': 'Italy',
      'ES': 'Spain',
      'NL': 'Netherlands',
      'UA': 'Ukraine',
      'KZ': 'Kazakhstan',
      'UZ': 'Uzbekistan',
    };
    final countryName = isoToCountry[countryCode];
    return kCountryDialCodes[countryName] ?? '+91';
  }

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool _isSavingBrandKit = false;
  bool get isSavingBrandKit => _isSavingBrandKit;

  String? _saveMessage;
  String? get saveMessage => _saveMessage;

  String? _brandKitMessage;
  String? get brandKitMessage => _brandKitMessage;

  ProfileViewModel() {
    dialCode = _detectDialCodeFromLocale();
    final user = AuthService.currentUser;
    final meta = user?.userMetadata;
    _profile = UserProfile(
      name:
          meta?['full_name'] as String? ??
          meta?['name'] as String? ??
          user?.email?.split('@').first ??
          '',
      email: user?.email ?? '',
      photoUrl:
          meta?['avatar_url'] as String? ?? meta?['picture'] as String? ?? '',
      phone: meta?['phone'] as String? ?? '',
      tier: SubscriptionTier.free,
    );
    phoneController.text = _profile.phone;
    _loadFromDatabase();
  }

  Future<void> _loadFromDatabase() async {
    final userId = AuthService.currentUser!.id;
    final client = Supabase.instance.client;

    debugPrint('[ProfileViewModel] userId: $userId');

    try {
      final profileFuture = client
          .from('profiles')
          .select('phone, dial_code, institution_name, tagline, institution_email, website, address, key_offerings, usp')
          .eq('id', userId)
          .maybeSingle();
      final subFuture = client
          .from('subscriptions')
          .select('tier, renewal_date, used_images, used_videos, total_campaigns, total_images, total_videos, total_print_materials')
          .eq('id', userId)
          .maybeSingle();

      final results = await Future.wait<dynamic>([profileFuture, subFuture]);

      final data = results[0] as Map<String, dynamic>?;
      final subData = results[1] as Map<String, dynamic>?;

      debugPrint('[ProfileViewModel] subData: $subData');

      final tierStr = subData?['tier'] as String? ?? 'free';
      debugPrint('[ProfileViewModel] tierStr: "$tierStr"');
      final tier = SubscriptionTier.values.firstWhere(
        (t) => t.name == tierStr,
        orElse: () => SubscriptionTier.free,
      );
      debugPrint('[ProfileViewModel] parsed tier: $tier');

      _profile = _profile.copyWith(
        tier: tier,
        renewalDate: subData?['renewal_date'] != null
            ? DateTime.tryParse(subData!['renewal_date'] as String)
            : null,
        usedImages: subData?['used_images'] as int? ?? 0,
        usedVideos: subData?['used_videos'] as int? ?? 0,
        totalCampaigns: subData?['total_campaigns'] as int? ?? 0,
        totalImages: subData?['total_images'] as int? ?? 0,
        totalVideos: subData?['total_videos'] as int? ?? 0,
        totalPrintMaterials: subData?['total_print_materials'] as int? ?? 0,
      );

      if (data != null) {
        if (data['dial_code'] != null && (data['dial_code'] as String).isNotEmpty) {
          dialCode = data['dial_code'] as String;
        }
        if (data['phone'] != null && (data['phone'] as String).isNotEmpty) {
          _profile = _profile.copyWith(phone: data['phone'] as String);
          phoneController.text = _profile.phone;
        }
        institutionController.text = data['institution_name'] ?? '';
        taglineController.text = data['tagline'] ?? '';
        institutionEmailController.text = data['institution_email'] ?? '';
        websiteController.text = data['website'] ?? '';
        addressController.text = data['address'] ?? '';
        keyOfferingsController.text = data['key_offerings'] ?? '';
        uspController.text = data['usp'] ?? '';
      }
      notifyListeners();
    } catch (e, st) {
      debugPrint('[ProfileViewModel] _loadFromDatabase error: $e');
      debugPrint('[ProfileViewModel] Stack: $st');
    }
  }

  Future<void> saveAccountChanges() async {
    _isSaving = true;
    _saveMessage = null;
    notifyListeners();

    try {
      await AuthService.updatePhone(phoneController.text);
      await Supabase.instance.client.from('profiles').upsert({
        'id': AuthService.currentUser!.id,
        'phone': phoneController.text,
        'dial_code': dialCode,
      });
      await AuthService.updatePhone('${dialCode}${phoneController.text}');
      
      _profile = _profile.copyWith(phone: phoneController.text);
      _saveMessage = 'Phone number saved';
    } catch (e, st) {
      debugPrint('[ProfileViewModel] saveAccountChanges error: $e');
      debugPrint('[ProfileViewModel] Stack: $st');
      _saveMessage =
          'Failed to save: ${e.toString().replaceFirst('Exception: ', '')}';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void resetBrandKit() {
    institutionController.clear();
    taglineController.clear();
    institutionEmailController.clear();
    websiteController.clear();
    addressController.clear();
    keyOfferingsController.clear();
    uspController.clear();
    _profile = _profile.copyWith(
      institutionName: '',
      tagline: '',
      institutionEmail: '',
      website: '',
      address: '',
      keyOfferings: '',
      usp: '',
    );
    notifyListeners();
  }

  Future<void> saveBrandKit() async {
    _isSavingBrandKit = true;
    _brandKitMessage = null;
    notifyListeners();

    try {
      await Supabase.instance.client.from('profiles').upsert({
        'id': AuthService.currentUser!.id,
        if (institutionController.text.isNotEmpty) 'institution_name': institutionController.text,
        if (taglineController.text.isNotEmpty) 'tagline': taglineController.text,
        if (institutionEmailController.text.isNotEmpty) 'institution_email': institutionEmailController.text,
        if (websiteController.text.isNotEmpty) 'website': websiteController.text,
        if (addressController.text.isNotEmpty) 'address': addressController.text,
        if (keyOfferingsController.text.isNotEmpty) 'key_offerings': keyOfferingsController.text,
        if (uspController.text.isNotEmpty) 'usp': uspController.text,
      });
      _profile = _profile.copyWith(
        institutionName: institutionController.text,
        tagline: taglineController.text,
        institutionEmail: institutionEmailController.text,
        website: websiteController.text,
        address: addressController.text,
        keyOfferings: keyOfferingsController.text,
        usp: uspController.text,
      );
      _brandKitMessage = 'Brand Kit saved';
    } catch (e, st) {
      debugPrint('[ProfileViewModel] saveBrandKit error: $e');
      debugPrint('[ProfileViewModel] Stack: $st');
      _brandKitMessage = 'Failed to save: ${e.toString().replaceFirst('Exception: ', '')}';
    } finally {
      _isSavingBrandKit = false;
      notifyListeners();
    }
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
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD32F2F),
            ),
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
