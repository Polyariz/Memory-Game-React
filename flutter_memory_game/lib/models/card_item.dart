/// Модель карточки для игры
class CardItem {
  final String id;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  /// Создает копию карточки с измененными параметрами
  CardItem copyWith({
    String? id,
    String? imagePath,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardItem(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
