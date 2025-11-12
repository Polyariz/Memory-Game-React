import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import 'memory_card.dart';
import 'package:confetti/confetti.dart';

/// Сетка карточек (аналог Cards.jsx)
class CardsGrid extends StatefulWidget {
  const CardsGrid({super.key});

  @override
  State<CardsGrid> createState() => _CardsGridState();
}

class _CardsGridState extends State<CardsGrid> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        // Запускаем конфетти при завершении уровня
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (gameState.openedCards.length == gameState.cards.length &&
              gameState.cards.isNotEmpty) {
            _confettiController.play();
          }
        });

        return Stack(
          children: [
            Column(
              children: [
                // Отображение счета
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    'Score: ${gameState.score}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Сетка карточек
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: gameState.cards.map((card) {
                    final isFlipped = gameState.isCardOpen(card);
                    return MemoryCard(
                      card: card,
                      isFlipped: isFlipped,
                      onTap: () => gameState.onCardClick(card),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Конфетти
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.3,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
