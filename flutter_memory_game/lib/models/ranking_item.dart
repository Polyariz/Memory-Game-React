/// Модель элемента рейтинга
class RankingItem {
  final String name;
  final int score;
  final DateTime? createdAt;

  RankingItem({
    required this.name,
    required this.score,
    this.createdAt,
  });

  /// Создание из JSON (из Supabase)
  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      name: json['name'] as String,
      score: json['score'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Преобразование в JSON (для Supabase)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
    };
  }
}
