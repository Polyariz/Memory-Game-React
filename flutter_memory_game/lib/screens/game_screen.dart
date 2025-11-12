import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import '../services/supabase_service.dart';
import '../widgets/game_timer.dart';
import '../widgets/cards_grid.dart';
import '../widgets/ranking_list.dart';

/// Главный экран игры (аналог App.jsx)
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _showWarning = false;
  bool _showError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Обработка сохранения результата
  Future<void> _handleSave() async {
    final gameState = Provider.of<GameState>(context, listen: false);
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _showWarning = true;
        _showError = false;
      });
      return;
    }

    setState(() {
      _showWarning = false;
    });

    // Сохранение результата
    final success = await SupabaseService.saveScore(name, gameState.score);

    if (success) {
      // Успешно сохранено, перезагружаем игру
      if (mounted) {
        gameState.resetGame();
        _nameController.clear();
        setState(() {
          _showError = false;
        });
      }
    } else {
      // Ошибка (возможно, имя уже существует)
      setState(() {
        _showError = true;
        _errorMessage = 'Имя уже существует';
      });
    }
  }

  /// Обработка кнопки "Снова"
  void _handleAgain() {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.resetGame();
    _nameController.clear();
    setState(() {
      _showWarning = false;
      _showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFB9DBFE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Consumer<GameState>(
                builder: (context, gameState, child) {
                  return Column(
                    children: [
                      // Заголовок
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7FBFFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'MEMORY GAME',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF2893ff),
                                offset: const Offset(3, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Таймер
                      const GameTimer(),

                      // Кнопки управления
                      _buildButtons(gameState),

                      // Рейтинг
                      const RankingList(),

                      // Сетка карточек
                      const SizedBox(height: 20),
                      const CardsGrid(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Построение кнопок управления
  Widget _buildButtons(GameState gameState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Кнопка Start/Again
            if (!gameState.isStarted && !gameState.canSave)
              ElevatedButton(
                onPressed: () => gameState.startGame(),
                style: _buttonStyle(),
                child: const Text('Start'),
              )
            else
              ElevatedButton(
                onPressed: _handleAgain,
                style: _buttonStyle(),
                child: const Text('Again'),
              ),

            // Поле ввода имени и кнопка Save
            if (gameState.canSave) ...[
              const SizedBox(width: 5),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ваше имя',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: _showWarning ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: _showWarning ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: _showWarning
                            ? Colors.red
                            : const Color(0xFF7FBFFF),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: _handleSave,
                style: _buttonStyle(),
                child: const Text('Save'),
              ),
            ],
          ],
        ),

        // Сообщение об ошибке
        if (_showError)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Color(0xFF2893ff),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  /// Стиль кнопок
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1a1a1a),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(
          color: Color(0xFF7FBFFF),
          width: 2,
        ),
      ),
    );
  }
}
