import 'package:flutter/material.dart';

// Owns the bottom nav and swaps tab bodies with IndexedStack so each
// tab keeps its own state and scroll position when you switch away and back.
//
// The three tabs below are inline placeholders. As each feature branch
// lands, replace the placeholder with an import of the real screen, e.g.
//   import '../features/map/screens/pharmacy_map_screen.dart';
//   ...
//   const PharmacyMapScreen(),
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _selectedIndex = 0;

  static const _tabs = [
    _PlaceholderTab(label: 'Search'),
    _PlaceholderTab(label: 'Map'),
    _PlaceholderTab(label: 'Profile'),
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
