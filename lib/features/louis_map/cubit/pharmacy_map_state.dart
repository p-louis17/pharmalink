import 'package:geolocator/geolocator.dart';
import '../models/pharmacy.dart';

/// Sealed so the UI's switch/if-chain is exhaustive — Dart will warn you
/// if you forget to handle one of these in the screen.
sealed class PharmacyMapState {}

class PharmacyMapLoading extends PharmacyMapState {}

class PharmacyMapLoaded extends PharmacyMapState {
  final Position userPosition;
  final List<Pharmacy> pharmacies;
  final Pharmacy? selectedPharmacy; // null = no marker tapped, hide detail card

  PharmacyMapLoaded({
    required this.userPosition,
    required this.pharmacies,
    this.selectedPharmacy,
  });

  /// Returns a copy with just selectedPharmacy changed — used when a
  /// marker is tapped or the map is tapped to dismiss the detail card.
  /// Keeps the cubit from re-fetching location/pharmacies just to
  /// change which one is selected.
  PharmacyMapLoaded copyWith({Pharmacy? selectedPharmacy, bool clearSelection = false}) {
    return PharmacyMapLoaded(
      userPosition: userPosition,
      pharmacies: pharmacies,
      selectedPharmacy: clearSelection ? null : (selectedPharmacy ?? this.selectedPharmacy),
    );
  }
}

class PharmacyMapError extends PharmacyMapState {
  final String message;
  PharmacyMapError(this.message);
}
