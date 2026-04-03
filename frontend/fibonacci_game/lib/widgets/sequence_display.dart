import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Displays the Fibonacci sequence as a wrapping flow of number chips.
/// Numbers are stored as strings (BigInt-safe on Flutter Web).
/// When the sequence grows beyond one line, chips wrap to the next line
/// automatically — no horizontal scroll needed, large numbers stay visible.
class SequenceDisplay extends StatelessWidget {
  final List<String> sequence;
  final bool? lastWasCorrect;

  const SequenceDisplay({
    super.key,
    required this.sequence,
    this.lastWasCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      children: [
        ...List.generate(sequence.length, (index) {
          final isLast = index == sequence.length - 1;
          final isHighlighted = isLast && lastWasCorrect == true;

          return _NumberChip(
            number: sequence[index],
            isHighlighted: isHighlighted,
            showComma: index < sequence.length - 1,
          );
        }),
        // "?" chip for the position the player needs to guess
        const _QuestionChip(),
      ],
    );
  }
}

// =====================================================================
// NUMBER CHIP
// =====================================================================

class _NumberChip extends StatelessWidget {
  final String number;
  final bool isHighlighted;
  /// Whether to render a trailing comma (all chips except the last known number)
  final bool showComma;

  const _NumberChip({
    required this.number,
    required this.isHighlighted,
    required this.showComma,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.correctGreen.withOpacity(0.18)
                : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlighted ? AppTheme.correctGreen : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            number,
            style: TextStyle(
              color: isHighlighted ? AppTheme.correctGreen : AppTheme.onBackground,
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (showComma)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              ',',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}

// =====================================================================
// QUESTION CHIP
// =====================================================================

class _QuestionChip extends StatelessWidget {
  const _QuestionChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primary,
          width: 2,
        ),
      ),
      child: Text(
        '?',
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
