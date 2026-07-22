import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/user_profile.dart';
import '../models/pharmacy.dart';
import '../services/firestore_service.dart';
import '../widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onViewMap;

  const ProfileScreen({super.key, this.onViewMap});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<UserProfile?>(
        stream: service.watchUserProfile(),
        builder: (context, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          final user = userSnap.data;
          if (user == null) {
            return const Center(child: Text('No profile found.'));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 8),

              // --- Brand pill: "PharmaLink" ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_pharmacy_rounded,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'PharmaLink',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Avatar, name, verified badge ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Icon(
                              Icons.person,
                              size: 36,
                              color: Colors.grey.shade600,
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (user.isVerifiedPatient) const VerifiedBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Saved Pharmacies ---
              SectionLabel(
                'Saved Pharmacies',
                trailing: TextButton(
                  onPressed: onViewMap,
                  child: Text(
                    'View Map',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              StreamBuilder<List<Pharmacy>>(
                stream: service.watchSavedPharmacies(),
                builder: (context, snap) {
                  final pharmacies = snap.data ?? [];
                  if (pharmacies.isEmpty) {
                    return SectionCard(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No saved pharmacies yet.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SectionCard(
                    children: [
                      for (int i = 0; i < pharmacies.length; i++)
                        PharmacyTile(
                          pharmacy: pharmacies[i],
                          onTap: () {
                            // TODO: once a pharmacy detail screen exists, push to it here
                          },
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Health Profile ---
              const SectionLabel('Health Profile'),
              SectionCard(
                children: [
                  SettingsTile(
                    icon: Icons.shield_outlined,
                    label: 'Insurance Information',
                    iconBg: AppTheme.primary.withValues(alpha: 0.1),
                    iconFg: AppTheme.primary,
                    onTap: () {
                      // TODO: navigate to insurance info screen once it exists
                    },
                  ),
                  SettingsTile(
                    icon: Icons.medication_outlined,
                    label: 'Current Prescriptions',
                    showDivider: false,
                    onTap: () {
                      // TODO: navigate to prescriptions screen once it exists
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- App Settings ---
              const SectionLabel('App Settings'),
              SectionCard(
                children: [
                  SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notification Preferences',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Privacy & Security',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Support ---
              const SectionLabel('Support'),
              SectionCard(
                children: [
                  SettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help Center',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Contact Support',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Log Out ---
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await service.signOut();
                    // TODO: once your team's login/auth screen exists, navigate back to it
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: AppTheme.danger,
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.danger,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- Footer version info ---
              Center(
                child: Text(
                  'PharmaLink Version ${user.appVersion} (Build 892)\n'
                  'Source: Mello API · Last Sync ${_lastSyncLabel(user.lastSyncAt)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _lastSyncLabel(DateTime? time) {
    if (time == null) return 'just now';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
