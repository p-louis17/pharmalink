import 'package:flutter/material.dart';
import '../features/faith_search_detail/screens/search_detail.dart';


// Owns the bottom nav and swaps tab bodies with IndexedStack so each
// tab keeps its own state and scroll position when you switch away and back.
//
// The four tabs below are inline placeholders. As each feature branch
// lands, replace the matching placeholder with an import of the real screen, e.g.
//   import '../features/louis_map/screens/pharmacy_map_screen.dart';
//   ...
//   const PharmacyMapScreen(),
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
    SearchResultsScreen(),   // faith_search_detail
    _PlaceholderTab(label: 'Map'),      // louis_map
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
