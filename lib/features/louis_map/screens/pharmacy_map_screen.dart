import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../cubit/pharmacy_map_cubit.dart';
import '../cubit/pharmacy_map_state.dart';
import '../models/pharmacy.dart';
import '../widgets/pharmacy_detail_card.dart';

class PharmacyMapScreen extends StatelessWidget {
  const PharmacyMapScreen({super.key});

  Color _markerColorFor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.limited:
        return Colors.purple;
      case StockStatus.unavailable:
        return Colors.red;
      case StockStatus.unknown:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PharmacyMapCubit, PharmacyMapState>(
        builder: (context, state) {
          if (state is PharmacyMapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PharmacyMapError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<PharmacyMapCubit>().loadNearbyPharmacies(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final loaded = state as PharmacyMapLoaded;
          final cubit = context.read<PharmacyMapCubit>();
          final userLatLng = LatLng(loaded.userPosition.latitude, loaded.userPosition.longitude);

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: userLatLng,
                  initialZoom: 14,
                  onTap: (_, __) => cubit.clearSelection(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // Required by OSM's tile usage policy — identifies your app
                    userAgentPackageName: 'com.pharmalink.app',
                  ),
                  MarkerLayer(
                    markers: [
                      // User's own position
                      Marker(
                        point: userLatLng,
                        width: 24,
                        height: 24,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                      ...loaded.pharmacies.map((p) {
                        return Marker(
                          point: LatLng(p.lat, p.lng),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => cubit.selectPharmacy(p),
                            child: Icon(
                              Icons.location_on,
                              color: _markerColorFor(p.stockStatus),
                              size: 36,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  // Required attribution — OSM's usage policy mandates this be visible
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('© OpenStreetMap contributors'),
                    ],
                  ),
                ],
              ),

              // Search bar overlay
              Positioned(
                top: 16, left: 16, right: 16,
                child: SafeArea(
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search medication or pharmacy',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              if (loaded.selectedPharmacy != null)
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: PharmacyDetailCard(
                  pharmacy: loaded.selectedPharmacy!,
                  userPosition: loaded.userPosition,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
