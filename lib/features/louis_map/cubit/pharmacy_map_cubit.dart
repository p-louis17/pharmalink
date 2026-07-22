import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/overpass_service.dart';
import '../models/pharmacy.dart';
import 'pharmacy_map_state.dart';

class PharmacyMapCubit extends Cubit<PharmacyMapState> {
  final LocationService _locationService;
  final OverpassService _overpassService;

  PharmacyMapCubit(this._locationService, this._overpassService) : super(PharmacyMapLoading());

  Future<void> loadNearbyPharmacies() async {
    emit(PharmacyMapLoading());
    try {
      final position = await _locationService.getCurrentPosition();
      final rawResults = await _overpassService.searchNearbyPharmacies(position: position);
      final pharmacies = rawResults.map(Pharmacy.fromOverpassJson).toList();

      emit(PharmacyMapLoaded(userPosition: position, pharmacies: pharmacies));
    } on LocationServiceException catch (e) {
      emit(PharmacyMapError(e.message));
    } on OverpassServiceException catch (e) {
      emit(PharmacyMapError(e.message));
    } catch (e) {
      emit(PharmacyMapError('Something went wrong: $e'));
    }
  }

  void selectPharmacy(Pharmacy pharmacy) {
    final current = state;
    if (current is PharmacyMapLoaded) {
      emit(current.copyWith(selectedPharmacy: pharmacy));
    }
  }

  void clearSelection() {
    final current = state;
    if (current is PharmacyMapLoaded) {
      emit(current.copyWith(clearSelection: true));
    }
  }
}
