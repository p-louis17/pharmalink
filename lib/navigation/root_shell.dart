import 'package:flutter/material.dart';
import '../features/louis_map/screens/pharmacy_map_screen.dart';

// Owns the bottom nav and swaps tab bodies with IndexedStack so each
// tab keeps its own state and scroll position when you switch away and back.
//
// Other placeholders get replaced the same way as each feature branch lands:
//   import '../features/ralph_home/screens/home_screen.dart';
//   import '../features/faith_search_detail/screens/search_screen.dart';
//   import '../features/raquel_profile/screens/profile_screen.dart';
//
// Note: blessing_pharmacy_detail is NOT a tab — it's a detail screen
// pushed (Navigator.push) from Home, Search, or Map when a pharmacy is tapped.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    _PlaceholderTab(label: 'Home'),     // ralph_home
    _PlaceholderTab(label: 'Search'),   // faith_search_detail
    PharmacyMapScreen(),                // louis_map
    _PlaceholderTab(label: 'Profile'),  // raquel_profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$label — coming soon')),
    );
  }
}
