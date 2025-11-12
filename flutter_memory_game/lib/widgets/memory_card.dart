import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import '../models/card_item.dart';

/// Виджет карточки с анимацией переворота (аналог Item.jsx)
class MemoryCard extends StatefulWidget {
  final CardItem card;
  final bool isFlipped;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle >= math.pi / 2
                ? Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _buildCardFront(),
                  )
                : _buildCardBack(),
          );
        },
      ),
    );
  }

  /// Задняя сторона карточки (с вопросительным знаком)
  Widget _buildCardBack() {
    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/question.png',
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.help_outline, size: 80, color: Colors.grey);
          },
        ),
      ),
    );
  }

  /// Передняя сторона карточки (с изображением)
  Widget _buildCardFront() {
    final isSvg = widget.card.imagePath.toLowerCase().endsWith('.svg');

    return Container(
      width: 105,
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: isSvg
            ? SvgPicture.asset(
                widget.card.imagePath,
                width: 80,
                height: 80,
                placeholderBuilder: (context) => Icon(
                  _getIconForImage(widget.card.imagePath),
                  size: 60,
                  color: const Color(0xFF7FBFFF),
                ),
              )
            : Image.asset(
                widget.card.imagePath,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _getIconForImage(widget.card.imagePath),
                    size: 60,
                    color: const Color(0xFF7FBFFF),
                  );
                },
              ),
      ),
    );
  }

  /// Получить иконку для изображения (запасной вариант)
  IconData _getIconForImage(String path) {
    if (path.contains('docker')) return Icons.widgets;
    if (path.contains('github')) return Icons.code;
    if (path.contains('javascript')) return Icons.javascript;
    if (path.contains('vscode')) return Icons.code;
    return Icons.image;
  }
}
