class ReelConfig {
  final String prompt;
  final String reelDuration;
  final String reelStyle;
  final String musicGenre;
  final String targetPlatform;
  final String videoQuality;
  final String scriptLanguage;
  final bool includeCaptions;
  final bool includeVoiceoverScript;

  const ReelConfig({
    this.prompt = '',
    this.reelDuration = '30 seconds — Standard Reel',
    this.reelStyle = 'Cinematic & Emotional',
    this.musicGenre = 'Inspirational / Motivational',
    this.targetPlatform = 'Instagram Reels',
    this.videoQuality = '1080p HD (1080×1920)',
    this.scriptLanguage = 'English',
    this.includeCaptions = true,
    this.includeVoiceoverScript = false,
  });

  ReelConfig copyWith({
    String? prompt,
    String? reelDuration,
    String? reelStyle,
    String? musicGenre,
    String? targetPlatform,
    String? videoQuality,
    String? scriptLanguage,
    bool? includeCaptions,
    bool? includeVoiceoverScript,
  }) {
    return ReelConfig(
      prompt: prompt ?? this.prompt,
      reelDuration: reelDuration ?? this.reelDuration,
      reelStyle: reelStyle ?? this.reelStyle,
      musicGenre: musicGenre ?? this.musicGenre,
      targetPlatform: targetPlatform ?? this.targetPlatform,
      videoQuality: videoQuality ?? this.videoQuality,
      scriptLanguage: scriptLanguage ?? this.scriptLanguage,
      includeCaptions: includeCaptions ?? this.includeCaptions,
      includeVoiceoverScript: includeVoiceoverScript ?? this.includeVoiceoverScript,
    );
  }
}
