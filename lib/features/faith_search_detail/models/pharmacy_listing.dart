import 'package:cloud_firestore/cloud_firestore.dart';

enum StockStatus { inStock, lowStock, unavailable }

class PharmacyListing {
  final String medicineName;
  final String pharmacyName;
  final double distanceMiles;
  final StockStatus status;
  final DateTime? updatedAt;
  final int priceRwf;
  final String source;

  const PharmacyListing({
    required this.medicineName,
    required this.pharmacyName,
    required this.distanceMiles,
    required this.status,
    required this.updatedAt,
    required this.priceRwf,
    required this.source,
  });

  // Builds a listing from a "medicineStock" Firestore document.
  factory PharmacyListing.fromMap(Map<String, dynamic> data) {
    return PharmacyListing(
      medicineName: data['medicineName'] as String? ?? '',
      pharmacyName: data['pharmacyName'] as String? ?? '',
      distanceMiles: (data['distanceMiles'] as num?)?.toDouble() ?? 0,
      status: StockStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => StockStatus.unavailable,
      ),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      priceRwf: (data['priceRwf'] as num?)?.toInt() ?? 0,
      source: data['source'] as String? ?? 'Mello API',
    );
  }

  String get distanceLabel => '${distanceMiles.toStringAsFixed(1)} miles away';

  String get priceLabel => 'RWF ${priceRwf.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}';

  // Same "Xm/Xh/Xd ago" style used on the Profile screen.
  String get updatedAgoLabel {
    final at = updatedAt;
    if (at == null) return '—';
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
