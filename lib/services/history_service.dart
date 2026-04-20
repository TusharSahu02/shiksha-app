import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/campaign_history.dart';

class HistoryService {
  HistoryService._();

  static final _supabase = Supabase.instance.client;

  static Future<List<CampaignHistory>> fetchHistory() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final rows = await _supabase
        .from('campaign_history')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (rows as List).map((r) => CampaignHistory.fromJson(r as Map<String, dynamic>)).toList();
  }

  static Future<void> save({
    required String type,
    required String topic,
    String country = '',
    String language = '',
    required Map<String, dynamic> output,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final cleanOutput = Map<String, dynamic>.from(output);
      cleanOutput.remove('images');
      cleanOutput.remove('image');
      cleanOutput.remove('image_url');

      await _supabase.from('campaign_history').insert({
        'user_id': userId,
        'type': type,
        'topic': topic,
        'country': country,
        'language': language,
        'output': cleanOutput,
      });
    } catch (e) {
      debugPrint('[HistoryService] Failed to save history: $e');
    }
  }

  static Future<void> delete(String id) async {
    try {
      await _supabase.from('campaign_history').delete().eq('id', id);
    } catch (e) {
      debugPrint('[HistoryService] Failed to delete: $e');
    }
  }
}
