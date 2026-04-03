import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../providers/leaderboard_provider.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'info_screen.dart';

/// Main application layout with side navigation rail (desktop/web)
/// or bottom navigation bar (mobile).
/// 
/// Navigation destinations:
/// 0 - Game
/// 1 - Leaderboard
/// 2 - Info
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.sports_esports_outlined,
      selectedIcon: Icons.sports_esports_rounded,
      label: 'Game',
    ),
    _NavItem(
      icon: Icons.leaderboard_outlined,
      selectedIcon: Icons.leaderboard_rounded,
      label: 'Leaderboard',
    ),
    _NavItem(
      icon: Icons.info_outline_rounded,
      selectedIcon: Icons.info_rounded,
      label: 'Info',
    ),
  ];

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);

    // Refresh leaderboard every time the tab is opened
    if (index == 1) {
      context.read<LeaderboardProvider>().refresh();
    }
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const GameScreen();
      case 1:
        return const LeaderboardScreen();
      case 2:
        return const InfoScreen();
      default:
        return const GameScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use NavigationRail for wide screens (desktop/web), BottomNav for narrow
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return _WideLayout(
            selectedIndex: _selectedIndex,
            navItems: _navItems,
            onItemSelected: _onNavItemSelected,
            child: _buildCurrentScreen(),
          );
        } else {
          return _NarrowLayout(
            selectedIndex: _selectedIndex,
            navItems: _navItems,
            onItemSelected: _onNavItemSelected,
            child: _buildCurrentScreen(),
          );
        }
      },
    );
  }
}

// =====================================================================
// WIDE LAYOUT (NavigationRail - for desktop/web)
// =====================================================================

class _WideLayout extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const _WideLayout({
    required this.selectedIndex,
    required this.navItems,
    required this.onItemSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side navigation rail
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onItemSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
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
                ],
              ),
            ),
            destinations: navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          // Divider
          const VerticalDivider(
            width: 1,
            color: AppTheme.surfaceVariant,
          ),
          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}

// =====================================================================
// NARROW LAYOUT (BottomNavigationBar - for mobile)
// =====================================================================

class _NarrowLayout extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onItemSelected;
  final Widget child;

  const _NarrowLayout({
    required this.selectedIndex,
    required this.navItems,
    required this.onItemSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
            const Text('Fibonacci Game'),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surface,
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemSelected,
        destinations: navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon, color: AppTheme.primary),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
