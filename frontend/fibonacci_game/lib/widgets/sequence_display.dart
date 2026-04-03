import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Displays the Fibonacci sequence as a horizontal scrollable row of chips.
/// The last added number can be highlighted to give visual feedback.
class SequenceDisplay extends StatelessWidget {
  final List<int> sequence;
  final bool? lastWasCorrect;

  const SequenceDisplay({
    super.key,
    required this.sequence,
    this.lastWasCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(sequence.length, (index) {
            // Highlight the last number if it was just added
            final isLast = index == sequence.length - 1;
            final isHighlighted = isLast && lastWasCorrect == true;

            return _NumberChip(
              number: sequence[index],
              isHighlighted: isHighlighted,
              isFirst: index == 0,
            );
          }),
          // Placeholder showing the unknown next number
          const _QuestionChip(),
        ],
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  final int number;
  final bool isHighlighted;
  final bool isFirst;

  const _NumberChip({
    required this.number,
    required this.isHighlighted,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              ',',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.correctGreen.withOpacity(0.2)
                : AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlighted ? AppTheme.correctGreen : AppTheme.surface,
              width: 2,
            ),
          ),
          child: Text(
            number.toString(),
            style: TextStyle(
              color: isHighlighted ? AppTheme.correctGreen : AppTheme.onBackground,
              fontSize: 18,
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionChip extends StatelessWidget {
  const _QuestionChip();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            ',',
            style: TextStyle(
              color: AppTheme.onSurface,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
