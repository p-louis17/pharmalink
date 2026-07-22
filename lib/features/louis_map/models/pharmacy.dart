enum StockStatus { inStock, limited, unavailable, unknown }

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final StockStatus stockStatus;
  final String? lastUpdatedLabel;
  final String? phone;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.stockStatus = StockStatus.unknown,
    this.lastUpdatedLabel,
    this.phone,
  });

  /// Builds a Pharmacy from one OSM node returned by Overpass.
  /// OSM tags are inconsistent per-place — a lot of pharmacies will have
  /// a name but no address, so everything here falls back gracefully.
  factory Pharmacy.fromOverpassJson(Map<String, dynamic> json) {
    final tags = json['tags'] as Map<String, dynamic>? ?? {};

    final addressParts = [
      tags['addr:street'],
      tags['addr:city'],
    ].whereType<String>();

    return Pharmacy(
      id: json['id'].toString(),
      name: tags['name'] as String? ?? 'Unnamed pharmacy',
      address: addressParts.isEmpty ? 'Address not available' : addressParts.join(', '),
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lon'] as num?)?.toDouble() ?? 0.0,
      stockStatus: StockStatus.unknown,
    );

    return Pharmacy(
      id: json['id'].toString(),
      name: tags['name'] as String? ?? 'Unnamed pharmacy',
      address: addressParts.isEmpty ? 'Address not available' : addressParts.join(', '),
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lon'] as num?)?.toDouble() ?? 0.0,
      stockStatus: StockStatus.unknown,
      phone: tags['phone'] as String? ?? tags['contact:phone'] as String?,
    );
  }
}
