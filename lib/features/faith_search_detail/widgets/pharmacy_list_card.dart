import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/pharmacy_listing.dart';

// One row in the results list — icon avatar, name/distance, then a
// status/updated/price strip, then the data source footnote.
class PharmacyListCard extends StatelessWidget {
  final PharmacyListing listing;
  final VoidCallback? onTap;

  const PharmacyListCard({super.key, required this.listing, this.onTap});

  Color get _statusColor {
    switch (listing.status) {
      case StockStatus.inStock:
        return AppTheme.accent;
      case StockStatus.lowStock:
        return AppTheme.danger;
      case StockStatus.unavailable:
        return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (listing.status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.unavailable:
        return 'Unavailable';
    }
  }

  IconData get _avatarIcon {
    switch (listing.status) {
      case StockStatus.inStock:
        return Icons.local_pharmacy_outlined;
      case StockStatus.lowStock:
        return Icons.warning_amber_rounded;
      case StockStatus.unavailable:
        return Icons.remove_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_avatarIcon, color: _statusColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.pharmacyName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            listing.distanceLabel,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LabelValue(
                        label: 'Status',
                        value: _statusLabel,
                        valueColor: _statusColor,
                      ),
                    ),
                    Expanded(
                      child: _LabelValue(
                        label: 'Updated',
                        value: listing.updatedAgo,
                      ),
                    ),
                    _LabelValue(
                      label: 'Price',
                      value: listing.priceLabel,
                      alignEnd: true,
                      bold: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Source: ${listing.source}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool alignEnd;
  final bool bold;

  const _LabelValue({
    required this.label,
    required this.value,
    this.valueColor,
    this.alignEnd = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
