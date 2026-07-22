import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

/// Queries OpenStreetMap's Overpass API for nearby amenities.
/// No API key needed. Tries multiple public mirrors in order since
/// any single free instance can go down or start rate-limiting.
///
/// IMPORTANT: Overpass servers now reject requests that look automated —
/// a descriptive User-Agent and explicit Accept header are required or
/// you'll get 406 Not Acceptable even with a perfectly valid query.
class OverpassService {
  static const _endpoints = [
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
  ];

  static const _headers = {
    'User-Agent': 'PharmaLinkApp/1.0 (ALU student project; contact: p.nsigos@alustudent.com)',
    'Accept': 'application/json',
  };

  Future<List<Map<String, dynamic>>> searchNearbyPharmacies({
    required Position position,
    double radiusMeters = 3000,
  }) async {
    final query = '''
[out:json][timeout:25];
node["amenity"="pharmacy"](around:$radiusMeters,${position.latitude},${position.longitude});
out body;
''';

    Exception? lastError;
    for (final endpoint in _endpoints) {
      try {
        final response = await http.post(
          Uri.parse(endpoint),
          headers: _headers,
          body: {'data': query},
        ).timeout(const Duration(seconds: 20));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return List<Map<String, dynamic>>.from(data['elements'] ?? []);
        }
        lastError = OverpassServiceException(
          'Overpass API error (${response.statusCode}) from $endpoint',
        );
      } catch (e) {
        lastError = OverpassServiceException('$e');
      }
    }
    throw lastError ?? OverpassServiceException('All Overpass endpoints failed');
  }
}

class OverpassServiceException implements Exception {
  final String message;
  OverpassServiceException(this.message);

  @override
  String toString() => message;
}
