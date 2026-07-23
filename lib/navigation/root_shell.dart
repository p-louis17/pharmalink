import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../features/ralph_auth/screens/login_screen.dart';
import '../features/ralph_home/screens/home_screen.dart';
import '../features/louis_map/screens/pharmacy_map_screen.dart';
import '../features/faith_search_detail/screens/search_detail.dart';
import '../features/racheal_profile/screens/profile_screen.dart';

// Owns the bottom nav and swaps tab bodies with IndexedStack so each
// tab keeps its own state and scroll position when you switch away and back.
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

  // Passed to HomeScreen so its logged-in taps (Quick Access, profile icon)
  // can jump straight to a tab instead of going through the login screen.
  void _goToTab(int index) => setState(() => _selectedIndex = index);

  // Search, Map, and Profile all require login — Home (index 0) doesn't.
  // Tapping one of them while logged out opens the login screen instead
  // of switching tabs.
  void _onTabTapped(int index) {
    final isLoggedIn = AuthService().currentUser != null;
    if (index != 0 && !isLoggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    _goToTab(index);
  }

  List<Widget> get _tabs => [
        HomeScreen(onNavigateToTab: _goToTab),         // ralph_home
        SearchResultsScreen(onNavigateToTab: _goToTab),// faith_search_detail
        const PharmacyMapScreen(),                     // louis_map
        ProfileScreen(onNavigateToTab: _goToTab),      // racheal_profile
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
