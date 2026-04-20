enum CampaignType { text, image, video, print }

class CampaignHistory {
  final String id;
  final String topic;
  final String country;
  final String language;
  final CampaignType type;
  final DateTime createdAt;
  final Map<String, dynamic> output;

  const CampaignHistory({
    required this.id,
    required this.topic,
    required this.country,
    required this.language,
    required this.type,
    required this.createdAt,
    this.output = const {},
  });

  factory CampaignHistory.fromJson(Map<String, dynamic> json) {
    return CampaignHistory(
      id: json['id'] as String,
      topic: json['topic'] as String? ?? '',
      country: json['country'] as String? ?? '',
      language: json['language'] as String? ?? '',
      type: CampaignType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => CampaignType.text,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      output: json['output'] as Map<String, dynamic>? ?? {},
    );
  }
}

extension CampaignTypeX on CampaignType {
  String get label {
    switch (this) {
      case CampaignType.text:
        return 'Text';
      case CampaignType.image:
        return 'Image';
      case CampaignType.video:
        return 'Video';
      case CampaignType.print:
        return 'Print';
    }
  }
}
