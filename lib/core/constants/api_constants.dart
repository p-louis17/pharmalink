// Keys and endpoints shared across features.
// Never hardcode a real key here — pass it in with --dart-define
// and read it with String.fromEnvironment, e.g.:
//   flutter run --dart-define=GOOGLE_MAPS_API_KEY=xxxx
class ApiConstants {
  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

  static const String placesNearbySearchUrl =
      'https://places.googleapis.com/v1/places:searchNearby';
}
