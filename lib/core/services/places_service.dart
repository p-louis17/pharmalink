import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../constants/api_constants.dart';

/// Wraps the Places API (New) nearby-search endpoint.
/// Returns raw decoded JSON maps — the map feature turns these into
/// Pharmacy objects, keeping this service reusable for other features
/// (e.g. if Faith's search screen also needs to look up places later).
class PlacesService {
  Future<List<Map<String, dynamic>>> searchNearby({
    required Position position,
    required String includedType, // e.g. 'pharmacy'
    double radiusMeters = 3000,
    int maxResults = 20,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.placesNearbySearchUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': ApiConstants.googleMapsApiKey,
        // Field mask keeps the response (and cost) small — add fields here
        // as features need them, e.g. places.regularOpeningHours.
        'X-Goog-FieldMask':
            'places.id,places.displayName,places.formattedAddress,places.location',
      },
      body: jsonEncode({
        'includedTypes': [includedType],
        'maxResultCount': maxResults,
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': position.latitude,
              'longitude': position.longitude,
            },
            'radius': radiusMeters,
          }
        }
      }),
    );

    if (response.statusCode != 200) {
      throw PlacesServiceException(
        'Places API error (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['places'] ?? []);
  }
}

class PlacesServiceException implements Exception {
  final String message;
  PlacesServiceException(this.message);

  @override
  String toString() => message;
}
