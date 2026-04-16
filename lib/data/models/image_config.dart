class ImageConfig {
  final String imageType;
  final String topic;
  final String institution;
  final String aspectRatio;
  final String visualStyle;
  final String colorScheme;
  final bool includeTextOverlay;
  final String headline;
  final String subText;
  final int variantCount;

  const ImageConfig({
    this.imageType = 'Admission Poster',
    this.topic = '',
    this.institution = '',
    this.aspectRatio = '1:1 Square (Instagram Post / Profile)',
    this.visualStyle = 'Photorealistic',
    this.colorScheme = 'Orange & White (Brand Colors)',
    this.includeTextOverlay = true,
    this.headline = '',
    this.subText = '',
    this.variantCount = 1,
  });

  ImageConfig copyWith({
    String? imageType,
    String? topic,
    String? institution,
    String? aspectRatio,
    String? visualStyle,
    String? colorScheme,
    bool? includeTextOverlay,
    String? headline,
    String? subText,
    int? variantCount,
  }) {
    return ImageConfig(
      imageType: imageType ?? this.imageType,
      topic: topic ?? this.topic,
      institution: institution ?? this.institution,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      visualStyle: visualStyle ?? this.visualStyle,
      colorScheme: colorScheme ?? this.colorScheme,
      includeTextOverlay: includeTextOverlay ?? this.includeTextOverlay,
      headline: headline ?? this.headline,
      subText: subText ?? this.subText,
      variantCount: variantCount ?? this.variantCount,
    );
  }
}
