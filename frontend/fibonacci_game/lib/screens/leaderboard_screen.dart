import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';
import '../models/leaderboard_entry.dart';
import '../utils/app_theme.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/error_message.dart';

/// Leaderboard screen showing the top 10 game results.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load leaderboard on first visit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LeaderboardProvider>();
      if (!provider.hasLoaded) {
        provider.loadLeaderboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(builder: (context, constraints) {
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
                        const Icon(
                          Icons.leaderboard_rounded,
                          color: AppTheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Top 10 Leaderboard',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: provider.isLoading ? null : provider.refresh,
                          icon: provider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primary,
                                  ),
                                )
                              : const Icon(Icons.refresh_rounded, color: AppTheme.primary),
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Content
                    if (provider.isLoading && !provider.hasLoaded)
                      const LoadingSpinner(message: 'Loading leaderboard...')
                    else if (provider.errorMessage != null)
                      ErrorMessage(
                        message: provider.errorMessage!,
                        onRetry: provider.loadLeaderboard,
                      )
                    else if (provider.entries.isEmpty)
                      _EmptyLeaderboard()
                    else
                      _LeaderboardTable(entries: provider.entries),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              color: AppTheme.onSurface,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No results yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to complete a game!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardTable extends StatelessWidget {
  final List<LeaderboardEntry> entries;

  const _LeaderboardTable({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Column headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                flex: 3,
                child: Text(
                  'Player',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  'Score',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  'Duration',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppTheme.surfaceVariant),
        // Entries
        ...entries.map((entry) => _LeaderboardRow(entry: entry)),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;

  const _LeaderboardRow({required this.entry});

  Color get _rankColor {
    switch (entry.rank) {
      case 1:
        return AppTheme.goldRank1;
      case 2:
        return AppTheme.silverRank2;
      case 3:
        return AppTheme.bronzeRank3;
      default:
        return AppTheme.onSurface;
    }
  }

  Widget _buildRankBadge() {
    if (entry.rank <= 3) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _rankColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _rankColor, width: 1),
        ),
        child: Center(
          child: Icon(
            entry.rank == 1
                ? Icons.emoji_events_rounded
                : Icons.military_tech_rounded,
            color: _rankColor,
            size: 20,
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '#${entry.rank}',
          style: TextStyle(
            color: AppTheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            _buildRankBadge(),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.playerName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onBackground,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    dateFormat.format(entry.finishedAt.toLocal()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  Text(
                    entry.score.toString(),
                    style: TextStyle(
                      color: _rankColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'pts',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                entry.formattedDuration,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
