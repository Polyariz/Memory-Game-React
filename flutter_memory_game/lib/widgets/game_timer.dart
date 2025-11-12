import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/game_state.dart';

/// Таймер игры (аналог Timer.jsx)
class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  Timer? _timer;
  int _seconds = 60;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(GameState gameState) {
    _timer?.cancel();
    _seconds = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
        gameState.updateTimer(_seconds);
      } else {
        timer.cancel();
        gameState.updateTimer(0);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 60;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        // Управление таймером в зависимости от состояния игры
        // Используем addPostFrameCallback чтобы избежать вызовов setState во время build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (gameState.isTimerRunning && _timer?.isActive != true) {
              _startTimer(gameState);
            } else if (!gameState.isTimerRunning && _timer?.isActive == true) {
              _stopTimer();
            }
          }
        });

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_seconds',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Sec',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
