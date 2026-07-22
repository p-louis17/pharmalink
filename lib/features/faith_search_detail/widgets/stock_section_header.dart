import 'package:flutter/material.dart';

class StockSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color badgeColor;
  final bool expanded;
  final VoidCallback onTap;

  const StockSectionHeader({
    super.key,
    required this.title,
    required this.count,
    required this.badgeColor,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count ${count == 1 ? 'PHARMACY' : 'PHARMACIES'}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: badgeColor,
                ),
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
