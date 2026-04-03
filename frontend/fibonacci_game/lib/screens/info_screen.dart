import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Information screen with game description and credits.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 32),
                  const SizedBox(width: 12),
                  Text('About', style: theme.textTheme.headlineLarge),
                ],
              ),
              const SizedBox(height: 24),

              // About the game
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About the Game', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(
                        'Fibonacci Game is a browser-based quiz game where you test your knowledge '
                        'of the Fibonacci sequence. Starting from the well-known pair 0, 1, '
                        'you must correctly guess each successive number in the sequence.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The Fibonacci sequence is one of the most famous sequences in mathematics: '
                        'each number is the sum of the two preceding numbers. It appears in nature, '
                        'art, architecture, and computer science.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // The sequence explained
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('The Fibonacci Sequence', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Formula: F(n) = F(n-1) + F(n-2), with F(0) = 0 and F(1) = 1',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Rules
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rules', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.play_circle_outline,
                        title: 'Starting',
                        description: 'Enter your name and start a new game. '
                            'The sequence begins with: 0, 1',
                      ),
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.check_circle_outline,
                        title: 'Correct answer',
                        description: '+1 point, number added to sequence, '
                            'field highlights green',
                      ),
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.cancel_outlined,
                        title: 'Wrong answer',
                        description: '-1 life. You can retry the same position. '
                            'The sequence does not advance.',
                      ),
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.favorite_outline,
                        title: 'Lives',
                        description: 'You start with 3 lives. '
                            'Losing all 3 ends the game.',
                      ),
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.leaderboard_outlined,
                        title: 'Leaderboard',
                        description: 'Your result is automatically saved after the game ends. '
                            'Top 10 scores are shown on the leaderboard.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Special message
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.2),
                        AppTheme.secondary.withOpacity(0.2),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppTheme.goldRank1, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Special Note',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppTheme.goldRank1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jasiu jest super!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.onBackground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tech stack
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tech Stack', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      _TechItem(label: 'Frontend', value: 'Flutter Web'),
                      _TechItem(label: 'Backend', value: 'ASP.NET Core 8 Web API'),
                      _TechItem(label: 'Database', value: 'SQLite + Entity Framework Core 8'),
                      _TechItem(label: 'State', value: 'Provider + ChangeNotifier'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechItem extends StatelessWidget {
  final String label;
  final String value;

  const _TechItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
