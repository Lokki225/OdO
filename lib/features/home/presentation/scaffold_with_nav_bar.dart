import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _Tab(label: 'Accueil', icon: Icons.home_outlined, path: '/home'),
    _Tab(label: 'Agenda', icon: Icons.calendar_today_outlined, path: '/home/agenda'),
    _Tab(label: 'Pratique', icon: Icons.fitness_center_outlined, path: '/home/practice'),
    _Tab(label: 'Insights', icon: Icons.auto_awesome_outlined, path: '/home/insights'),
    _Tab(label: 'Profil', icon: Icons.person_outline, path: '/home/profile'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) => context.go(_tabs[index].path),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.label, required this.icon, required this.path});
  final String label;
  final IconData icon;
  final String path;
}
