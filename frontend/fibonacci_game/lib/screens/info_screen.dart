import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.watch<LanguageProvider>().strings;

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
                  const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primary, size: 32),
                  const SizedBox(width: 12),
                  Text(s.infoTitle, style: theme.textTheme.headlineLarge),
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
                      Text(s.infoAboutTitle, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(s.infoAboutBody, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text(s.infoAboutBody2, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // The sequence
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.infoSequenceTitle,
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
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
                      Text(s.infoFormula,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic)),
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
                      Text(s.infoRulesTitle, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 16),
                      _InfoRow(
                          icon: Icons.play_circle_outline,
                          title: s.infoRuleStartTitle,
                          description: s.infoRuleStartDesc),
                      const Divider(height: 24),
                      _InfoRow(
                          icon: Icons.check_circle_outline,
                          title: s.infoRuleCorrectTitle,
                          description: s.infoRuleCorrectDesc),
                      const Divider(height: 24),
                      _InfoRow(
                          icon: Icons.cancel_outlined,
                          title: s.infoRuleWrongTitle,
                          description: s.infoRuleWrongDesc),
                      const Divider(height: 24),
                      _InfoRow(
                          icon: Icons.favorite_outline,
                          title: s.infoRuleLivesTitle,
                          description: s.infoRuleLivesDesc),
                      const Divider(height: 24),
                      _InfoRow(
                          icon: Icons.leaderboard_outlined,
                          title: s.infoRuleLeaderTitle,
                          description: s.infoRuleLeaderDesc),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Special note — "Jasiu jest super!"
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
                          const Icon(Icons.star_rounded,
                              color: AppTheme.goldRank1, size: 28),
                          const SizedBox(width: 8),
                          Text(s.infoSpecialTitle,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: AppTheme.goldRank1)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.infoSpecialMessage,
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
                      Text(s.infoTechTitle, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      _TechItem(
                          label: 'Frontend', value: s.infoTechFrontend),
                      _TechItem(
                          label: 'Backend', value: s.infoTechBackend),
                      _TechItem(
                          label: 'Database', value: s.infoTechDb),
                      _TechItem(
                          label: 'State', value: s.infoTechState),
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
  const _InfoRow(
      {required this.icon, required this.title, required this.description});

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
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(description,
                  style: Theme.of(context).textTheme.bodyMedium),
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
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.primary)),
        ],
      ),
    );
  }
}
