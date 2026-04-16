class CampaignConfig {
  final String topic;
  final String country;
  final String language;
  final String phone;

  const CampaignConfig({
    this.topic = '',
    this.country = 'India',
    this.language = 'Hinglish',
    this.phone = '',
  });

  CampaignConfig copyWith({
    String? topic,
    String? country,
    String? language,
    String? phone,
  }) {
    return CampaignConfig(
      topic: topic ?? this.topic,
      country: country ?? this.country,
      language: language ?? this.language,
      phone: phone ?? this.phone,
    );
  }
}
