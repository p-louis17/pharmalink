import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/pharmacy.dart';

const double _kSpacingSm = 8;
const double _kSpacingMd = 16;
const double _kCardRadius = 16;

/// Small gray label like "Health Profile", "App Settings".
class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _kSpacingMd,
        _kSpacingMd,
        _kSpacingMd,
        _kSpacingSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.2,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// The white rounded card wrapper used for every grouped section.
class SectionCard extends StatelessWidget {
  final List<Widget> children;
  const SectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kSpacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

/// A single row: circular icon + label + chevron.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconBg;
  final Color? iconFg;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.iconBg,
    this.iconFg,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _kSpacingMd,
              vertical: 14,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: iconBg ?? Colors.grey.shade200,
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconFg ?? Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: _kSpacingSm + 4),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(height: 1, indent: 52, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

/// The "Ubumwe Pharmacy · 0.8 km away" row.
class PharmacyTile extends StatelessWidget {
  final Pharmacy pharmacy;
  final VoidCallback? onTap;

  const PharmacyTile({super.key, required this.pharmacy, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kSpacingMd,
          vertical: 14,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.local_pharmacy_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: _kSpacingSm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Updated recently',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Text(
              pharmacy.distanceLabel,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

/// Teal "Verified Patient" pill — uses AppTheme.accent, your team's
/// positive-status color (also used for "in stock").
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Verified Patient',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.accent,
        ),
      ),
    );
  }
}
