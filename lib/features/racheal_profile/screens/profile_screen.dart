import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import '../widgets/profile_widgets.dart';

const List<String> _kMonthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

class ProfileScreen extends StatefulWidget {
  // Called with tab index 0 after logging out, so RootShell switches
  // back to the Home tab (which shows its logged-out state itself).
  final ValueChanged<int>? onNavigateToTab;

  const ProfileScreen({super.key, this.onNavigateToTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = FirestoreService.instance;
  bool _insuranceExpanded = true;
  bool _supportExpanded = false;

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Not set';
    return '${_kMonthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _openEditInfoDialog(UserProfile user) async {
    final nameController = TextEditingController(text: user.fullName);
    final phoneController = TextEditingController(text: user.phone ?? '');
    final addressController = TextEditingController(text: user.address ?? '');
    var selectedDob = user.dob;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Personal Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('DOB: ${_dateLabel(selectedDob)}')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDob ?? DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDob = picked);
                        }
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) {
      await _service.updateProfile(user.copyWith(
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        dob: selectedDob,
      ));
    }
  }

  Future<void> _openAddInsuranceDialog(UserProfile user) async {
    final controller = TextEditingController(text: user.insuranceProvider ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insurance Information'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. RSSB, Radiant, MMI',
            labelText: 'Insurance provider',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _service.updateProfile(user.copyWith(insuranceProvider: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: const Icon(Icons.local_pharmacy, color: AppTheme.primary),
        title: const Text(
          'PharmaLink',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<UserProfile?>(
        stream: _service.watchUserProfile(),
        builder: (context, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          // Signing out mid-stream makes Firestore's listener throw a
          // permission-denied error (rules require auth.uid == userId) —
          // treat that the same as "no profile" instead of leaving it
          // unhandled.
          final user = userSnap.hasError ? null : userSnap.data;
          if (user == null) {
            return const Center(child: Text('No profile found.'));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const SizedBox(height: 16),

              // --- Avatar, name, email, verified badge ---
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, size: 36, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.email!,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                    const SizedBox(height: 6),
                    if (user.isVerifiedPatient) const VerifiedBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Personal Information ---
              SectionLabel(
                'Personal Information',
                trailing: IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: AppTheme.primary),
                  onPressed: () => _openEditInfoDialog(user),
                ),
              ),
              SectionCard(
                children: [
                  InfoRow(icon: Icons.person_outline, label: 'Full Name', value: user.fullName),
                  InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email ?? 'Not set'),
                  InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: user.phone ?? 'Not set'),
                  InfoRow(icon: Icons.calendar_today_outlined, label: 'Date of Birth', value: _dateLabel(user.dob)),
                  InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: user.address ?? 'Not set',
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Insurance Information ---
              ExpandableSection(
                icon: Icons.shield_outlined,
                title: 'Insurance Information',
                expanded: _insuranceExpanded,
                onToggle: () => setState(() => _insuranceExpanded = !_insuranceExpanded),
                children: [
                  if (user.insuranceProvider == null || user.insuranceProvider!.isEmpty) ...[
                    const Text(
                      'No insurance information added.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add your insurance details to make your pharmacy experience better.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _openAddInsuranceDialog(user),
                        child: const Text('Add Insurance'),
                      ),
                    ),
                  ] else ...[
                    Text(
                      user.insuranceProvider!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _openAddInsuranceDialog(user),
                      child: const Text('Edit'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // --- Contact Support ---
              ExpandableSection(
                icon: Icons.support_agent_outlined,
                title: 'Contact Support',
                expanded: _supportExpanded,
                onToggle: () => setState(() => _supportExpanded = !_supportExpanded),
                children: const [
                  Text('pharmaLink@techsupport.com', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('+2349340034043', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 24),

              // --- Log Out ---
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await _service.signOut();
                    widget.onNavigateToTab?.call(0);
                  },
                  icon: Icon(Icons.logout_rounded, size: 18, color: AppTheme.danger),
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
