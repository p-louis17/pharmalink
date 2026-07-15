import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/pharmacy.dart';
import 'pharmacy_actions.dart';

class PharmacyDetailCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final Position userPosition;
  const PharmacyDetailCard({super.key, required this.pharmacy, required this.userPosition});

  Color _statusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.limited:
        return Colors.purple;
      case StockStatus.unavailable:
        return Colors.red;
      case StockStatus.unknown:
        return Colors.grey;
    }
  }

  String _statusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.limited:
        return 'Limited';
      case StockStatus.unavailable:
        return 'Unavailable';
      case StockStatus.unknown:
        return 'Stock unknown';
    }
  }

  String _distanceLabel() {
    final meters = Geolocator.distanceBetween(
      userPosition.latitude, userPosition.longitude,
      pharmacy.lat, pharmacy.lng,
    );
    return meters < 1000 ? '${meters.round()}m away' : '${(meters / 1000).toStringAsFixed(1)}km away';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(pharmacy.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(pharmacy.stockStatus).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(pharmacy.stockStatus),
                    style: TextStyle(color: _statusColor(pharmacy.stockStatus), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(pharmacy.address, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 2),
            Text(_distanceLabel(), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pharmacy.phone == null
                        ? null
                        : () async {
                            try {
                              await PharmacyActions.callPharmacy(pharmacy.phone!);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not open dialer')),
                                );
                              }
                            }
                          },
                    icon: const Icon(Icons.call, size: 18),
                    label: Text(pharmacy.phone == null ? 'No number' : 'Call'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await PharmacyActions.openDirections(pharmacy);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open directions')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
