// A single pharmacy's stock listing for a searched drug.
// Mock data lives in screen.dart for now — swap for an API-backed
// repository once the backend contract is ready.

enum StockStatus { inStock, lowStock, unavailable }

class PharmacyListing {
  final String pharmacyName;
  final double distanceMiles;
  final StockStatus status;
  final String updatedAgo;
  final int priceRwf;
  final String source;

  const PharmacyListing({
    required this.pharmacyName,
    required this.distanceMiles,
    required this.status,
    required this.updatedAgo,
    required this.priceRwf,
    required this.source,
  });

  String get distanceLabel => '${distanceMiles.toStringAsFixed(1)} miles away';

  String get priceLabel => 'RWF ${priceRwf.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}';
}
