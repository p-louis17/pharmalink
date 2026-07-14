import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../ralph_auth/screens/login_screen.dart';

// Home tab — first screen users see, no login required.
// Logged-out: Find Pharmacies, Quick Access cards, and the topbar button
// all push to the login screen.
// Logged-in: those same actions jump straight to their placeholder tab,
// and the topbar shows a profile icon that jumps to the Profile tab.
class HomeScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomeScreen({super.key, this.onNavigateToTab});

  // Simple data for the 3 quick access cards. tabIndex matches the bottom
  // nav order in root_shell.dart: Home 0, Search 1, Map 2, Profile 3.
  static const List<Map<String, dynamic>> _quickAccessItems = [
    {
      'icon': Icons.map_outlined,
      'title': 'Map Explorer',
      'subtitle': 'View pharmacies near you',
      'tabIndex': 2,
    },
    {
      'icon': Icons.search,
      'title': 'Search Medicine',
      'subtitle': 'Check availability and prices',
      'tabIndex': 1,
    },
    {
      'icon': Icons.description_outlined,
      'title': 'My Health',
      'subtitle': 'Prescriptions and health info',
      'tabIndex': 3,
    },
  ];

  // Simple data for the health tips list.
  static const List<Map<String, dynamic>> _healthTips = [
    {
      'icon': Icons.water_drop_outlined,
      'color': Colors.blue,
      'title': 'Stay Hydrated',
      'description': 'Drink enough water every day to keep your body healthy.',
    },
    {
      'icon': Icons.eco_outlined,
      'color': Colors.green,
      'title': 'Eat Balanced',
      'description': 'Eat fruits, vegetables and whole foods for a stronger immune system.',
    },
    {
      'icon': Icons.directions_run,
      'color': Colors.orange,
      'title': 'Stay Active',
      'description': '30 minutes of activity daily can improve your overall well-being.',
    },
    {
      'icon': Icons.nightlight_round,
      'color': Colors.purple,
      'title': 'Get Enough Rest',
      'description': 'Good sleep helps your body recover and stay healthy.',
    },
    {
      'icon': Icons.medication_outlined,
      'color': Colors.red,
      'title': 'Use Medicines Safely',
      'description': 'Always follow instructions and store medicines properly.',
    },
  ];

  // Sends the person to the login screen — used for logged-out taps.
  void _requiresLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // Switches the bottom nav to the given tab — used for logged-in taps.
  void _goToTab(int index) => onNavigateToTab?.call(index);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data != null;

        return Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.local_pharmacy, color: AppTheme.primary),
            title: const Text(
              'PharmaLink',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
            ),
            actions: [
              isLoggedIn
                  ? IconButton(
                      icon: const Icon(Icons.account_circle, color: AppTheme.primary),
                      onPressed: () => _goToTab(3),
                    )
                  : TextButton(
                      onPressed: () => _requiresLogin(context),
                      child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeroCard(context, isLoggedIn),
              const SizedBox(height: 24),
              const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              for (final item in _quickAccessItems)
                _QuickAccessCard(
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  subtitle: item['subtitle'] as String,
                  onTap: () => isLoggedIn
                      ? _goToTab(item['tabIndex'] as int)
                      : _requiresLogin(context),
                ),
              const SizedBox(height: 24),
              const Text('Health Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _healthTips.length; i++)
                      _HealthTipTile(
                        icon: _healthTips[i]['icon'] as IconData,
                        color: _healthTips[i]['color'] as Color,
                        title: _healthTips[i]['title'] as String,
                        description: _healthTips[i]['description'] as String,
                        showDivider: i != _healthTips.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isLoggedIn) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: AppTheme.primary, size: 16),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Verified Pharmacies. Trusted Care.',
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Find verified pharmacies and medicines near you.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => isLoggedIn ? _goToTab(2) : _requiresLogin(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Find Pharmacies Near Me',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// One card in the "Quick Access" section.
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

// One row in the "Health Tips" list.
class _HealthTipTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final bool showDivider;

  const _HealthTipTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
