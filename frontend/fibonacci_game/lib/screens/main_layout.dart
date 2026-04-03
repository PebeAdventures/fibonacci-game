import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/leaderboard_provider.dart';
import '../utils/app_theme.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'info_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      context.read<LeaderboardProvider>().refresh();
    }
  }

  Widget _buildCurrentScreen() {
    return switch (_selectedIndex) {
      0 => const GameScreen(),
      1 => const LeaderboardScreen(),
      2 => const InfoScreen(),
      _ => const GameScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        return isWide
            ? _WideLayout(
                selectedIndex: _selectedIndex,
                onItemSelected: _onNavItemSelected,
                child: _buildCurrentScreen(),
              )
            : _NarrowLayout(
                selectedIndex: _selectedIndex,
                onItemSelected: _onNavItemSelected,
                child: _buildCurrentScreen(),
              );
      },
    );
  }
}

// =====================================================================
// LANGUAGE TOGGLE BUTTON — shared by both layouts
// =====================================================================

class _LangToggle extends StatelessWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Tooltip(
        message: lang.isPolish ? 'Switch to English' : 'Przełącz na Polski',
        child: InkWell(
          onTap: lang.toggle,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
            ),
            child: Text(
              lang.isPolish ? 'EN' : 'PL',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// WIDE LAYOUT
// =====================================================================

class _WideLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const _WideLayout({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;

    final destinations = [
      (icon: Icons.sports_esports_outlined, sel: Icons.sports_esports_rounded, label: s.navGame),
      (icon: Icons.leaderboard_outlined, sel: Icons.leaderboard_rounded, label: s.navLeaderboard),
      (icon: Icons.info_outline_rounded, sel: Icons.info_rounded, label: s.navInfo),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onItemSelected,
            labelType: NavigationRailLabelType.all,
            leading: Column(
              children: [
                const SizedBox(height: 16),
                // App logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'F(n)',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const _LangToggle(),
              ],
            ),
            destinations: destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.sel),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1, color: AppTheme.surfaceVariant),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// =====================================================================
// NARROW LAYOUT
// =====================================================================

class _NarrowLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const _NarrowLayout({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<LanguageProvider>().strings;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary),
              ),
              child: const Center(
                child: Text(
                  'F(n)',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(s.appTitle),
          ],
        ),
        actions: const [
          _LangToggle(),
          SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surface,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.sports_esports_outlined),
            selectedIcon: const Icon(Icons.sports_esports_rounded, color: AppTheme.primary),
            label: s.navGame,
          ),
          NavigationDestination(
            icon: const Icon(Icons.leaderboard_outlined),
            selectedIcon: const Icon(Icons.leaderboard_rounded, color: AppTheme.primary),
            label: s.navLeaderboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.info_outline_rounded),
            selectedIcon: const Icon(Icons.info_rounded, color: AppTheme.primary),
            label: s.navInfo,
          ),
        ],
      ),
    );
  }
}
