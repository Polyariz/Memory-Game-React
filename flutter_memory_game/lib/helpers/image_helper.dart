import '../models/card_item.dart';

/// Хелпер для работы с изображениями карточек
class ImageHelper {
  // Список всех доступных изображений
  static const List<String> _allImages = [
    "assets/images/bun.svg",
    "assets/images/deno.svg",
    "assets/images/docker.svg",
    "assets/images/redis.svg",
    "assets/images/vitejs.svg",
    "assets/images/github.svg",
    "assets/images/javascript.svg",
    "assets/images/supabase.svg",
    "assets/images/svelte.svg",
    "assets/images/vscode.svg",
  ];

  /// Получить список карточек для игры
  /// size - количество уникальных изображений (будет создано size * 2 карточек)
  static List<CardItem> getImages(int size) {
    // Берем первые size изображений
    final selectedImages = _allImages.take(size).toList();

    // Создаем пары карточек
    final List<CardItem> cards = [];

    for (int i = 0; i < selectedImages.length; i++) {
      final imagePath = selectedImages[i];
      // Создаем две карточки с одинаковым изображением
      cards.add(CardItem(
        id: '1|$imagePath',
        imagePath: imagePath,
      ));
      cards.add(CardItem(
        id: '2|$imagePath',
        imagePath: imagePath,
      ));
    }

    // Перемешиваем карточки случайным образом
    cards.shuffle();

    return cards;
  }

  /// Проверка, совпадают ли две карточки
  static bool doCardsMatch(CardItem card1, CardItem card2) {
    return card1.imagePath == card2.imagePath;
  }
}
