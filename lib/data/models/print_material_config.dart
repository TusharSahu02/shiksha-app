class PrintMaterialConfig {
  final String materialType;
  final String outputLanguage;
  final String outputSize;
  final String designStyle;
  final String targetAudience;
  final String topic;
  final String institution;
  final String tagline;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String keyOfferings;
  final String usp;
  final bool useInternetResearch;

  const PrintMaterialConfig({
    this.materialType = 'Tri-fold Brochure',
    this.outputLanguage = 'English',
    this.outputSize = 'A4 (210×297mm) — Standard',
    this.designStyle = 'Professional & Corporate',
    this.targetAudience = 'Students (Class 10-12)',
    this.topic = '',
    this.institution = '',
    this.tagline = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.address = '',
    this.keyOfferings = '',
    this.usp = '',
    this.useInternetResearch = true,
  });

  PrintMaterialConfig copyWith({
    String? materialType,
    String? outputLanguage,
    String? outputSize,
    String? designStyle,
    String? targetAudience,
    String? topic,
    String? institution,
    String? tagline,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? keyOfferings,
    String? usp,
    bool? useInternetResearch,
  }) {
    return PrintMaterialConfig(
      materialType: materialType ?? this.materialType,
      outputLanguage: outputLanguage ?? this.outputLanguage,
      outputSize: outputSize ?? this.outputSize,
      designStyle: designStyle ?? this.designStyle,
      targetAudience: targetAudience ?? this.targetAudience,
      topic: topic ?? this.topic,
      institution: institution ?? this.institution,
      tagline: tagline ?? this.tagline,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      address: address ?? this.address,
      keyOfferings: keyOfferings ?? this.keyOfferings,
      usp: usp ?? this.usp,
      useInternetResearch: useInternetResearch ?? this.useInternetResearch,
    );
  }
}
