import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CampaignService {
  CampaignService._();

  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>> generateCampaign({
    required String topic,
    required String country,
    required String language,
    String phone = '',
  }) async {
    debugPrint('=====================================================================================');
    debugPrint('[CampaignService] Calling generate-campaign...');
    debugPrint('[CampaignService] User: ${_supabase.auth.currentUser?.id}');
    debugPrint('[CampaignService] Session: ${_supabase.auth.currentSession != null}');
    debugPrint('=====================================================================================');

    final response = await _supabase.functions.invoke(
      'generate-campaign',
      body: {
        'topic': topic,
        'country': country,
        'language': language,
        'phone': phone,
      },
    );

    debugPrint('=====================================================================================');
    debugPrint('[CampaignService] Status: ${response.status}');
    debugPrint('[CampaignService] Data: ${response.data}');
    debugPrint('=====================================================================================');

    if (response.status != 200) {
      final error = response.data?['error'] ?? 'Unknown error';
      debugPrint('=====================================================================================');
      debugPrint('[CampaignService] ERROR: $error');
      debugPrint('=====================================================================================');
      throw Exception(error);
    }

    final campaign = response.data['campaign'] as Map<String, dynamic>;
    debugPrint('=====================================================================================');
    debugPrint('[CampaignService] Campaign keys: ${campaign.keys.toList()}');
    for (final key in campaign.keys) {
      debugPrint('[CampaignService] $key (${campaign[key].runtimeType}): ${campaign[key].toString().substring(0, campaign[key].toString().length.clamp(0, 100))}');
    }
    debugPrint('=====================================================================================');
    return campaign;
  }

  static Future<Map<String, dynamic>> generatePrintMaterial({
    required String topic,
    String materialType = '',
    String outputLanguage = '',
    String outputSize = '',
    String designStyle = '',
    String targetAudience = '',
    String institution = '',
    String tagline = '',
    String phone = '',
    String email = '',
    String website = '',
    String address = '',
    String keyOfferings = '',
    String usp = '',
  }) async {
    debugPrint('=====================================================================================');
    debugPrint('[CampaignService] Calling generate-print-material...');
    debugPrint('=====================================================================================');

    final response = await _supabase.functions.invoke(
      'generate-print-material',
      body: {
        'topic': topic,
        'materialType': materialType,
        'outputLanguage': outputLanguage,
        'outputSize': outputSize,
        'designStyle': designStyle,
        'targetAudience': targetAudience,
        'institution': institution,
        'tagline': tagline,
        'phone': phone,
        'email': email,
        'website': website,
        'address': address,
        'keyOfferings': keyOfferings,
        'usp': usp,
      },
    );

    debugPrint('=====================================================================================');
    debugPrint('[CampaignService] Print Material Status: ${response.status}');
    debugPrint('=====================================================================================');

    if (response.status != 200) {
      final error = response.data?['error'] ?? 'Unknown error';
      debugPrint('=====================================================================================');
      debugPrint('[CampaignService] PRINT ERROR: $error');
      debugPrint('=====================================================================================');
      throw Exception(error);
    }

    return response.data['material'] as Map<String, dynamic>;
  }
}
