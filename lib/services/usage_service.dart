import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsageService {
  UsageService._();

  static final _supabase = Supabase.instance.client;

  static Future<void> incrementCampaign() =>
      _increment('total_campaigns');

  static Future<void> incrementImage() =>
      _increment('total_images', monthlyColumn: 'used_images');

  static Future<void> incrementVideo() =>
      _increment('total_videos', monthlyColumn: 'used_videos');

  static Future<void> incrementPrintMaterial() =>
      _increment('total_print_materials');

  static Future<void> _increment(
    String totalColumn, {
    String? monthlyColumn,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final columns = [totalColumn, ?monthlyColumn].join(', ');

      final row = await _supabase
          .from('subscriptions')
          .select(columns)
          .eq('id', userId)
          .maybeSingle();

      if (row == null) return;

      final updates = <String, dynamic>{
        totalColumn: ((row[totalColumn] as int?) ?? 0) + 1,
      };
      if (monthlyColumn != null) {
        updates[monthlyColumn] = ((row[monthlyColumn] as int?) ?? 0) + 1;
      }

      await _supabase
          .from('subscriptions')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      debugPrint('[UsageService] Failed to increment $totalColumn: $e');
    }
  }
}
