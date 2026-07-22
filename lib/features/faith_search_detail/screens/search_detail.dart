import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/pharmacy_listing.dart';
import '../widgets/pharmacy_list_card.dart';
import '../widgets/stock_section_header.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

enum _ViewMode { list, map }

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _searchController = TextEditingController(text: 'Amoxicillin');
  _ViewMode _viewMode = _ViewMode.list;
  bool _inStockExpanded = true;
  bool _lowStockExpanded = true;

  // Mock data — replace with the real search results once the
  // faith_search_detail cubit/repository is wired up.
  static const _inStock = [
    PharmacyListing(
      pharmacyName: 'Ubumwe Pharmacy',
      distanceMiles: 1.2,
      status: StockStatus.inStock,
      updatedAgo: '2m ago',
      priceRwf: 500,
      source: 'Mello API',
    ),
    PharmacyListing(
      pharmacyName: 'Walgreens Specialty',
      distanceMiles: 2.4,
      status: StockStatus.inStock,
      updatedAgo: '5m ago',
      priceRwf: 590,
      source: 'Mello API',
    ),
  ];

  static const _lowStock = [
    PharmacyListing(
      pharmacyName: 'MedLink Local',
      distanceMiles: 3.1,
      status: StockStatus.lowStock,
      updatedAgo: '12m ago',
      priceRwf: 500,
      source: 'Mello API',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(PharmacyListing listing) {
    // TODO: Navigator.push to blessing_pharmacy_detail once that
    // screen exists, passing `listing` (or a pharmacy id) along.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.local_pharmacy, color: AppTheme.primary),
            const SizedBox(width: 8),
            const Text(
              'PharmaLink',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, color: AppTheme.primary, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  _SearchField(controller: _searchController),
                  const SizedBox(height: 12),
                  _ViewModeToggle(
                    mode: _viewMode,
                    onChanged: (mode) => setState(() => _viewMode = mode),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _viewMode == _ViewMode.list
                  ? _buildList()
                  : const Center(child: Text('Map view coming soon')),
            ),
          ],
        ),
      ),
      // No bottomNavigationBar here — RootShell already renders one
      // that's shared across all four tabs.
    );
  }

  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        StockSectionHeader(
          title: 'In Stock',
          count: _inStock.length,
          badgeColor: AppTheme.accent,
          expanded: _inStockExpanded,
          onTap: () => setState(() => _inStockExpanded = !_inStockExpanded),
        ),
        if (_inStockExpanded)
          ..._inStock.map(
            (l) => PharmacyListCard(listing: l, onTap: () => _openDetail(l)),
          ),
        const SizedBox(height: 8),
        StockSectionHeader(
          title: 'Low Stock',
          count: _lowStock.length,
          badgeColor: AppTheme.danger,
          expanded: _lowStockExpanded,
          onTap: () => setState(() => _lowStockExpanded = !_lowStockExpanded),
        ),
        if (_lowStockExpanded)
          ..._lowStock.map(
            (l) => PharmacyListCard(listing: l, onTap: () => _openDetail(l)),
          ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search medication',
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.tune, size: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  final _ViewMode mode;
  final ValueChanged<_ViewMode> onChanged;

  const _ViewModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'List',
              icon: Icons.reorder,
              selected: mode == _ViewMode.list,
              onTap: () => onChanged(_ViewMode.list),
            ),
          ),
          Expanded(
            child: _ToggleButton(
              label: 'Map',
              icon: Icons.map_outlined,
              selected: mode == _ViewMode.map,
              onTap: () => onChanged(_ViewMode.map),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.black87 : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
