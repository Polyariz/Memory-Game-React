import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ranking_item.dart';

/// Сервис для работы с Supabase (аналог supabaseClient.js)
class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Получить рейтинг (отсортирован по убыванию очков)
  static Future<List<RankingItem>> getRanking() async {
    try {
      final response = await _client
          .from('ranking')
          .select()
          .order('score', ascending: false);

      final List<RankingItem> ranking = [];
      for (var item in response) {
        ranking.add(RankingItem.fromJson(item));
      }

      return ranking;
    } catch (e) {
      print('Ошибка при загрузке рейтинга: $e');
      return [];
    }
  }

  /// Сохранить результат в рейтинг
  /// Возвращает true при успехе, false при ошибке (например, имя уже существует)
  static Future<bool> saveScore(String name, int score) async {
    if (name.isEmpty) {
      return false;
    }

    try {
      await _client.from('ranking').insert({
        'name': name,
        'score': score,
      });
      return true;
    } catch (e) {
      print('Ошибка при сохранении результата: $e');
      // Статус 409 означает конфликт (имя уже существует)
      return false;
    }
  }

  /// Проверить существование имени в рейтинге
  static Future<bool> checkNameExists(String name) async {
    try {
      final response = await _client
          .from('ranking')
          .select()
          .eq('name', name)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Ошибка при проверке имени: $e');
      return false;
    }
  }
}
