import 'package:flutter/foundation.dart';
import '../models/card_item.dart';
import '../helpers/image_helper.dart';

/// Управление состоянием игры (аналог React state)
class GameState extends ChangeNotifier {
  // Состояние игры
  bool _isStarted = false;
  bool _canSave = false;
  int _score = 0;
  int _level = 3; // Начальный размер (3 пары карточек)
  int _clicks = 0;

  // Карточки
  List<CardItem> _cards = [];
  List<CardItem> _selectedCards = [];
  List<CardItem> _openedCards = [];

  // Таймер
  int _remainingSeconds = 60;
  bool _isTimerRunning = false;

  // Геттеры
  bool get isStarted => _isStarted;
  bool get canSave => _canSave;
  int get score => _score;
  int get level => _level;
  int get clicks => _clicks;
  List<CardItem> get cards => _cards;
  List<CardItem> get selectedCards => _selectedCards;
  List<CardItem> get openedCards => _openedCards;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimerRunning => _isTimerRunning;

  /// Инициализация игры
  GameState() {
    _initializeGame();
  }

  void _initializeGame() {
    _cards = ImageHelper.getImages(_level);
    notifyListeners();
  }

  /// Начать игру
  void startGame() {
    _isStarted = true;
    _isTimerRunning = true;
    _remainingSeconds = 60;
    notifyListeners();
  }

  /// Обновить таймер
  void updateTimer(int seconds) {
    _remainingSeconds = seconds;
    if (seconds == 0) {
      _endGame();
    }
    notifyListeners();
  }

  /// Завершить игру
  void _endGame() {
    _isStarted = false;
    _canSave = true;
    _isTimerRunning = false;
    notifyListeners();
  }

  /// Обработка клика по карточке
  void onCardClick(CardItem card) {
    if (!_isStarted) return;
    if (_selectedCards.length >= 2) return;
    if (_selectedCards.contains(card)) return;
    if (_openedCards.contains(card)) return;

    _clicks++;
    _selectedCards.add(card);

    if (_selectedCards.length == 2) {
      _checkMatch();
    }

    notifyListeners();
  }

  /// Проверка совпадения карточек
  void _checkMatch() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_selectedCards.length == 2) {
        final card1 = _selectedCards[0];
        final card2 = _selectedCards[1];

        if (ImageHelper.doCardsMatch(card1, card2)) {
          // Карточки совпадают
          _openedCards.addAll(_selectedCards);

          // Проверка завершения уровня
          if (_openedCards.length == _cards.length) {
            _onLevelComplete();
          }
        }

        // Очистка выбранных карточек
        _selectedCards.clear();
        notifyListeners();
      }
    });
  }

  /// Завершение уровня
  void _onLevelComplete() {
    _calculateScore();
    _level += 2; // Увеличиваем сложность
    _clicks = 0;
    _selectedCards.clear();
    _openedCards.clear();
    _cards = ImageHelper.getImages(_level);
    notifyListeners();
  }

  /// Расчет очков (точно как в React версии)
  void _calculateScore() {
    final passLevel = _level * 10;
    final totalCards = _level * 2;
    int earnedPoints = 0;

    if (_clicks == totalCards) {
      // Идеальное прохождение
      earnedPoints = (totalCards * 2) + passLevel;
    } else if (_clicks > totalCards && _clicks < totalCards + 5) {
      // Хорошее прохождение
      earnedPoints = totalCards + passLevel;
    } else if (_clicks > totalCards + 5 && _clicks < totalCards + 10) {
      // Среднее прохождение
      earnedPoints = (totalCards / 2).round() + passLevel;
    } else {
      // Слабое прохождение
      earnedPoints = (totalCards / 3).round() + passLevel;
    }

    _score += earnedPoints;
  }

  /// Проверка, открыта ли карточка
  bool isCardOpen(CardItem card) {
    return _selectedCards.contains(card) || _openedCards.contains(card);
  }

  /// Перезагрузка игры
  void resetGame() {
    _isStarted = false;
    _canSave = false;
    _score = 0;
    _level = 3;
    _clicks = 0;
    _selectedCards.clear();
    _openedCards.clear();
    _remainingSeconds = 60;
    _isTimerRunning = false;
    _initializeGame();
    notifyListeners();
  }
}
