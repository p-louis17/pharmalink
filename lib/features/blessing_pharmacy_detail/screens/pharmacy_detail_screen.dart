import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../faith_search_detail/models/pharmacy_listing.dart';
import '../../faith_search_detail/services/search_service.dart';
import '../../louis_map/widgets/pharmacy_actions.dart';

// Pushed (Navigator.push) from Home, Search, or Map when a pharmacy is
// tapped. Only needs the pharmacy's name — everything shown here comes
// from that pharmacy's documents in the "medicineStock" collection, so
// there's nothing to show until at least one medicine is in stock there.
class PharmacyDetailScreen extends StatelessWidget {
  final String pharmacyName;

  const PharmacyDetailScreen({super.key, required this.pharmacyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Pharmacy Details'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<PharmacyListing>>(
        stream: SearchService().watchPharmacyStock(pharmacyName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _Banner(),
              const SizedBox(height: 16),
              Text(
                pharmacyName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  items.first.distanceLabel,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Medicines in Stock (${items.length})',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No medicines currently listed for this pharmacy.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                )
              else
                _StockCard(items: items),
              const SizedBox(height: 20),
              Text(
                'Opening Hours',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const _OpeningHoursCard(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => PharmacyActions.openDirectionsByName(pharmacyName),
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Directions'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Placeholder banner — medicineStock has no photo/map data per pharmacy,
// so this is just a simple branded header instead of a real map preview.
class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.local_pharmacy, size: 56, color: AppTheme.primary),
    );
  }
}

// One rounded card listing every medicine in stock, divided into rows —
// same look as the other stock cards in the app (faith_search_detail).
class _StockCard extends StatelessWidget {
  final List<PharmacyListing> items;

  const _StockCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _MedicineRow(item: items[i]),
            if (i != items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

// Every partner pharmacy currently keeps the same hours, so this is one
// static row rather than a per-day breakdown pulled from data we don't have.
class _OpeningHoursCard extends StatelessWidget {
  const _OpeningHoursCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppTheme.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Open Every Day', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          const Text('9:00 AM - 11:00 PM', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MedicineRow extends StatelessWidget {
  final PharmacyListing item;

  const _MedicineRow({required this.item});

  Color get _statusColor {
    switch (item.status) {
      case StockStatus.inStock:
        return AppTheme.accent;
      case StockStatus.lowStock:
        return AppTheme.danger;
      case StockStatus.unavailable:
        return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.unavailable:
        return 'Unavailable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicineName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.priceLabel,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Updated ${item.updatedAgoLabel}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              Text(
                'Source: ${item.source}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
