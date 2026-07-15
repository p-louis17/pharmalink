import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../models/pharmacy.dart';

/// Hands off to whatever maps/phone app is installed — no API key,
/// no in-app routing to maintain. Kept separate from the card widget
/// so any screen (map, search results, pharmacy detail) can reuse it.
class PharmacyActions {
  static Future<void> openDirections(Pharmacy pharmacy) async {
    final Uri uri = (!kIsWeb && Platform.isIOS)
        ? Uri.parse('https://maps.apple.com/?daddr=${pharmacy.lat},${pharmacy.lng}')
        : Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${pharmacy.lat},${pharmacy.lng}');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open maps for ${pharmacy.name}');
    }
  }

  static Future<void> callPharmacy(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch dialer');
    }
  }
}