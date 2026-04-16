enum CampaignType { text, image, video, print }

class CampaignHistory {
  final String id;
  final String topic;
  final String country;
  final String language;
  final CampaignType type;
  final DateTime createdAt;
  final String? thumbnailUrl;

  const CampaignHistory({
    required this.id,
    required this.topic,
    required this.country,
    required this.language,
    required this.type,
    required this.createdAt,
    this.thumbnailUrl,
  });
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
