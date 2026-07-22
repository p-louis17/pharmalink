/// Maps to a document in Firestore: users/{uid}/savedPharmacies/{pharmacyId}
class Pharmacy {
  final String id;
  final String name;
  final double distanceKm;
  final DateTime? updatedAt;
  final double? lat;
  final double? lng;

  Pharmacy({
    required this.id,
    required this.name,
    required this.distanceKm,
    this.updatedAt,
    this.lat,
    this.lng,
  });

  factory Pharmacy.fromMap(String id, Map<String, dynamic> data) {
    return Pharmacy(
      id: id,
      name: data['name'] as String? ?? '',
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'].toString())
          : null,
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'distanceKm': distanceKm,
      'updatedAt': updatedAt?.toIso8601String(),
      'lat': lat,
      'lng': lng,
    };
  }

  /// e.g. "0.8 km away" — matches the label style in the design
  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km away';
}
