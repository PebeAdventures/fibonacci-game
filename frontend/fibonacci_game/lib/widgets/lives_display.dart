import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Displays the player's remaining lives as heart icons.
/// Full hearts = remaining lives, empty hearts = lost lives.
class LivesDisplay extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesDisplay({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (index) {
        final isFull = index < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            isFull ? Icons.favorite : Icons.favorite_border,
            color: isFull ? AppTheme.wrongRed : AppTheme.onSurface,
            size: 24,
          ),
        );
      }),
    );
  }
}
