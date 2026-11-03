import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../widgets/spot_card.dart';
import 'spot_detail_screen.dart';

class SpotListScreen extends StatefulWidget {
  const SpotListScreen({super.key});

  @override
  State<SpotListScreen> createState() => _SpotListScreenState();
}

class _SpotListScreenState extends State<SpotListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final filteredSpots = AppConstants.flyingSpots.where((spot) {
      final matchesSearch = spot['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          spot['region']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'Semua' || spot['status'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Katalog Lokasi Terbang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 600;
          final int gridCols = constraints.maxWidth >= 950 ? 3 : 2;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 28.0 : 16.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari nama lapangan atau wilayah...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: ['Semua', 'Optimal', 'Waspada Angin'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: AppConstants.primaryMint.withValues(alpha: 0.2),
                        onSelected: (_) => setState(() => _selectedFilter = filter),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredSpots.isEmpty
                      ? const Center(
                          child: Text('Lokasi tidak ditemukan.'),
                        )
                      : isWide
                          ? GridView.builder(
                              itemCount: filteredSpots.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridCols,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 156,
                              ),
                              itemBuilder: (context, index) {
                                final spot = filteredSpots[index];
                                return SpotCard(
                                  spot: spot,
                                  margin: EdgeInsets.zero,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SpotDetailScreen(spot: spot),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: filteredSpots.length,
                              itemBuilder: (context, index) {
                                final spot = filteredSpots[index];
                                return SpotCard(
                                  spot: spot,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SpotDetailScreen(spot: spot),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}