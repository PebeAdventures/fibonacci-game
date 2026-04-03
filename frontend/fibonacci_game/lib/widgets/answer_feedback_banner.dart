import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Shows a brief feedback banner after the player submits an answer.
/// Green for correct answers, red for wrong answers.
class AnswerFeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String message;

  const AnswerFeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppTheme.correctGreen.withOpacity(0.15)
            : AppTheme.wrongRed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_outline : Icons.error_outline,
            color: isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
