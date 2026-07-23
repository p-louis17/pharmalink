import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../blessing_pharmacy_detail/screens/pharmacy_detail_screen.dart';
import '../models/pharmacy_listing.dart';
import '../services/search_service.dart';
import '../widgets/pharmacy_list_card.dart';
import '../widgets/stock_section_header.dart';

class SearchResultsScreen extends StatefulWidget {
  // Lets the profile icon jump to the Profile tab (index 3 in root_shell).
  final ValueChanged<int>? onNavigateToTab;

  const SearchResultsScreen({super.key, this.onNavigateToTab});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

// null = no filter, show every status.
class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _searchController = TextEditingController();
  final _searchService = SearchService();

  StockStatus? _statusFilter;
  bool _inStockExpanded = true;
  bool _lowStockExpanded = true;

  @override
  void initState() {
    super.initState();
    // Re-run the Firestore query on every keystroke.
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(PharmacyListing listing) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PharmacyDetailScreen(pharmacyName: listing.pharmacyName),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filter by stock status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              _FilterOption(
                label: 'All',
                selected: _statusFilter == null,
                onTap: () => setState(() => _statusFilter = null),
              ),
              _FilterOption(
                label: 'In Stock',
                selected: _statusFilter == StockStatus.inStock,
                onTap: () => setState(() => _statusFilter = StockStatus.inStock),
              ),
              _FilterOption(
                label: 'Low Stock',
                selected: _statusFilter == StockStatus.lowStock,
                onTap: () => setState(() => _statusFilter = StockStatus.lowStock),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
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
            child: IconButton(
              icon: Icon(Icons.account_circle, color: AppTheme.primary),
              onPressed: () => widget.onNavigateToTab?.call(3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _SearchField(
                controller: _searchController,
                onFilterTap: _openFilterSheet,
              ),
            ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      // No bottomNavigationBar here — RootShell already renders one
      // that's shared across all four tabs.
    );
  }

  Widget _buildList() {
    return StreamBuilder<List<PharmacyListing>>(
      stream: _searchService.watchListings(_searchController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }

        var results = snapshot.data ?? [];
        if (_statusFilter != null) {
          results = results.where((l) => l.status == _statusFilter).toList();
        }

        final inStock = results.where((l) => l.status == StockStatus.inStock).toList();
        final lowStock = results.where((l) => l.status == StockStatus.lowStock).toList();

        if (inStock.isEmpty && lowStock.isEmpty) {
          return const Center(child: Text('No stock results found.'));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            if (inStock.isNotEmpty) ...[
              StockSectionHeader(
                title: 'In Stock',
                count: inStock.length,
                badgeColor: AppTheme.accent,
                expanded: _inStockExpanded,
                onTap: () => setState(() => _inStockExpanded = !_inStockExpanded),
              ),
              if (_inStockExpanded)
                ...inStock.map(
                  (l) => PharmacyListCard(listing: l, onTap: () => _openDetail(l)),
                ),
              const SizedBox(height: 8),
            ],
            if (lowStock.isNotEmpty) ...[
              StockSectionHeader(
                title: 'Low Stock',
                count: lowStock.length,
                badgeColor: AppTheme.danger,
                expanded: _lowStockExpanded,
                onTap: () => setState(() => _lowStockExpanded = !_lowStockExpanded),
              ),
              if (_lowStockExpanded)
                ...lowStock.map(
                  (l) => PharmacyListCard(listing: l, onTap: () => _openDetail(l)),
                ),
            ],
          ],
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const _SearchField({required this.controller, required this.onFilterTap});

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
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.tune, size: 18, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected ? Icon(Icons.check, color: AppTheme.primary) : null,
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
    );
  }
}
