import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../utils/app_theme.dart';
import '../widgets/lives_display.dart';
import '../widgets/sequence_display.dart';
import '../widgets/answer_feedback_banner.dart';
import '../widgets/score_display.dart';
import '../widgets/loading_spinner.dart';

/// The main game screen.
/// 
/// Flow:
/// 1. Show NickEntry form (no active game)
/// 2. Show active game (sequence, input, lives, score)
/// 3. Show game over screen (final score, leaderboard rank)
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.gameState == null) {
          return const LoadingSpinner(message: 'Starting game...');
        }

        if (provider.gameState == null) {
          return _NickEntryView(provider: provider);
        }

        if (provider.gameState!.isGameOver) {
          return _GameOverView(provider: provider);
        }

        return _ActiveGameView(provider: provider);
      },
    );
  }
}

// =====================================================================
// NICK ENTRY VIEW
// =====================================================================

class _NickEntryView extends StatefulWidget {
  final GameProvider provider;

  const _NickEntryView({required this.provider});

  @override
  State<_NickEntryView> createState() => _NickEntryViewState();
}

class _NickEntryViewState extends State<_NickEntryView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.provider.startGame(_nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo / title
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'F(n)',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Text(
                'Fibonacci Game',
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'How far can you go in the sequence?',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Nick entry form
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter your name',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nick or name',
                            hintText: 'e.g. Jasiu',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _startGame(),
                          maxLength: 100,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().length < 1) {
                              return 'Name too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Error message if API failed
                        if (widget.provider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              widget.provider.errorMessage!,
                              style: const TextStyle(color: AppTheme.error),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ElevatedButton.icon(
                          onPressed: widget.provider.isLoading ? null : _startGame,
                          icon: widget.provider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start Game'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Rules
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How to play', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      _RuleItem(
                        icon: Icons.looks_one_outlined,
                        text: 'You start with sequence: 0, 1',
                      ),
                      _RuleItem(
                        icon: Icons.edit_outlined,
                        text: 'Guess the next Fibonacci number',
                      ),
                      _RuleItem(
                        icon: Icons.add_circle_outline,
                        text: '+1 point for each correct answer',
                      ),
                      _RuleItem(
                        icon: Icons.favorite_outlined,
                        text: '3 lives — wrong answers cost you one',
                      ),
                      _RuleItem(
                        icon: Icons.emoji_events_outlined,
                        text: 'Top 10 results saved to leaderboard',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RuleItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ACTIVE GAME VIEW
// =====================================================================

class _ActiveGameView extends StatefulWidget {
  final GameProvider provider;

  const _ActiveGameView({required this.provider});

  @override
  State<_ActiveGameView> createState() => _ActiveGameViewState();
}

class _ActiveGameViewState extends State<_ActiveGameView> {
  final _answerController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;

    final answer = int.tryParse(text);
    if (answer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    widget.provider.submitAnswer(answer);
    _answerController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.provider.gameState!;

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 700;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: player name, score, lives
                _GameHeader(state: state),
                const SizedBox(height: 24),

                // Sequence display
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sequence so far:', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        SequenceDisplay(
                          sequence: state.sequence,
                          lastWasCorrect: state.lastAnswerCorrect,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Feedback banner (shown after submitting)
                if (state.lastMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AnswerFeedbackBanner(
                      isCorrect: state.lastAnswerCorrect ?? false,
                      message: state.lastMessage!,
                    ),
                  ),

                // Error message (API errors)
                if (widget.provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AnswerFeedbackBanner(
                      isCorrect: false,
                      message: widget.provider.errorMessage!,
                    ),
                  ),

                // Answer input
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'What comes next?',
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          'Position: F(${state.currentIndex})',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Your answer',
                                  hintText: 'Enter a number',
                                  prefixIcon: Icon(Icons.calculate_outlined),
                                ),
                                onSubmitted: (_) => _submitAnswer(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: state.isLoading ? null : _submitAnswer,
                              icon: state.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check_rounded),
                              label: const Text('Confirm'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _GameHeader extends StatelessWidget {
  final GameState state;

  const _GameHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.playerName,
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Keep guessing!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        ScoreDisplay(score: state.score),
        const SizedBox(width: 16),
        LivesDisplay(lives: state.lives),
      ],
    );
  }
}

// =====================================================================
// GAME OVER VIEW
// =====================================================================

class _GameOverView extends StatelessWidget {
  final GameProvider provider;

  const _GameOverView({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = provider.gameState!;
    final savedResult = provider.savedResult;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Game over icon
              const Center(
                child: Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: AppTheme.error,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Game Over!',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppTheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Better luck next time, ${state.playerName}!',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Score card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('Final Score', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        state.score.toString(),
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text('points', style: theme.textTheme.bodyMedium),
                      if (savedResult != null) ...[
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getRankIcon(savedResult.rank),
                              color: _getRankColor(savedResult.rank),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rank #${savedResult.rank} on leaderboard!',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: _getRankColor(savedResult.rank),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Divider(height: 24),
                        Text(
                          'Saving your score...',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        const LinearProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sequence reached
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.format_list_numbered, color: AppTheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Reached F(${state.currentIndex}) in the sequence',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Play again button
              ElevatedButton.icon(
                onPressed: () => provider.resetGame(),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRankIcon(int rank) {
    if (rank == 1) return Icons.emoji_events_rounded;
    if (rank <= 3) return Icons.military_tech_rounded;
    if (rank <= 10) return Icons.leaderboard_rounded;
    return Icons.sports_score_rounded;
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return AppTheme.goldRank1;
    if (rank == 2) return AppTheme.silverRank2;
    if (rank == 3) return AppTheme.bronzeRank3;
    return AppTheme.primary;
  }
}
