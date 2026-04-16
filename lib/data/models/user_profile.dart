import 'subscription_tier.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String role;

  // Subscription
  final SubscriptionTier tier;
  final DateTime? renewalDate;
  final int usedImages;
  final int usedVideos;

  // Institution / Brand Kit
  final String institutionName;
  final String tagline;
  final String institutionEmail;
  final String website;
  final String address;
  final String keyOfferings;
  final String usp;
  final String brandColor;

  // Default Campaign Preferences
  final String defaultCountry;
  final String defaultLanguage;
  final String defaultAudience;
  final String defaultPlatform;

  // Stats
  final int totalCampaigns;
  final int totalImages;
  final int totalVideos;
  final int totalPrintMaterials;

  // Notifications
  final bool notifyOnComplete;
  final bool notifyWeeklySummary;
  final bool notifyNewFeatures;
  final bool notifyRenewal;

  const UserProfile({
    this.name = 'Tushar Sahu',
    this.email = 'demomail.tushar@gmail.com',
    this.phone = '+91 98765 43210',
    this.role = 'User',
    this.tier = SubscriptionTier.free,
    this.renewalDate,
    this.usedImages = 0,
    this.usedVideos = 0,
    this.institutionName = '',
    this.tagline = '',
    this.institutionEmail = '',
    this.website = '',
    this.address = '',
    this.keyOfferings = '',
    this.usp = '',
    this.brandColor = '#F0A030',
    this.defaultCountry = 'India',
    this.defaultLanguage = 'Hinglish',
    this.defaultAudience = 'Students (Class 10-12)',
    this.defaultPlatform = 'Instagram Reels',
    this.totalCampaigns = 0,
    this.totalImages = 0,
    this.totalVideos = 0,
    this.totalPrintMaterials = 0,
    this.notifyOnComplete = true,
    this.notifyWeeklySummary = true,
    this.notifyNewFeatures = true,
    this.notifyRenewal = true,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    SubscriptionTier? tier,
    DateTime? renewalDate,
    int? usedImages,
    int? usedVideos,
    String? institutionName,
    String? tagline,
    String? institutionEmail,
    String? website,
    String? address,
    String? keyOfferings,
    String? usp,
    String? brandColor,
    String? defaultCountry,
    String? defaultLanguage,
    String? defaultAudience,
    String? defaultPlatform,
    int? totalCampaigns,
    int? totalImages,
    int? totalVideos,
    int? totalPrintMaterials,
    bool? notifyOnComplete,
    bool? notifyWeeklySummary,
    bool? notifyNewFeatures,
    bool? notifyRenewal,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      tier: tier ?? this.tier,
      renewalDate: renewalDate ?? this.renewalDate,
      usedImages: usedImages ?? this.usedImages,
      usedVideos: usedVideos ?? this.usedVideos,
      institutionName: institutionName ?? this.institutionName,
      tagline: tagline ?? this.tagline,
      institutionEmail: institutionEmail ?? this.institutionEmail,
      website: website ?? this.website,
      address: address ?? this.address,
      keyOfferings: keyOfferings ?? this.keyOfferings,
      usp: usp ?? this.usp,
      brandColor: brandColor ?? this.brandColor,
      defaultCountry: defaultCountry ?? this.defaultCountry,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      defaultAudience: defaultAudience ?? this.defaultAudience,
      defaultPlatform: defaultPlatform ?? this.defaultPlatform,
      totalCampaigns: totalCampaigns ?? this.totalCampaigns,
      totalImages: totalImages ?? this.totalImages,
      totalVideos: totalVideos ?? this.totalVideos,
      totalPrintMaterials: totalPrintMaterials ?? this.totalPrintMaterials,
      notifyOnComplete: notifyOnComplete ?? this.notifyOnComplete,
      notifyWeeklySummary: notifyWeeklySummary ?? this.notifyWeeklySummary,
      notifyNewFeatures: notifyNewFeatures ?? this.notifyNewFeatures,
      notifyRenewal: notifyRenewal ?? this.notifyRenewal,
    );
  }
}
