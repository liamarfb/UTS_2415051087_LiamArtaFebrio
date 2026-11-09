import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../providers/weather_provider.dart';
import '../widgets/spot_card.dart';
import '../widgets/state_status_view.dart';
import 'spot_detail_screen.dart';

class SpotListScreen extends StatelessWidget {
  const SpotListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final filteredSpots = weatherProv.filteredSpots;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Katalog Lokasi Terbang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat Ulang API',
            onPressed: weatherProv.isLoading
                ? null
                : () => weatherProv.fetchLiveWeatherSpots(),
            icon: const Icon(Icons.refresh, color: AppConstants.primaryMint),
          ),
          PopupMenuButton<bool?>(
            tooltip: 'Urutkan Kecepatan Angin',
            icon: const Icon(Icons.sort, color: AppConstants.primaryMint),
            onSelected: (value) {
              weatherProv.setWindSort(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value == null
                        ? 'Urutan dikembalikan ke default'
                        : value
                            ? 'Diurutkan: Angin paling tenang'
                            : 'Diurutkan: Angin paling kencang',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: null,
                child: Text('Urutan Default'),
              ),
              PopupMenuItem(
                value: true,
                child: Text('Angin Terendah → Tertinggi'),
              ),
              PopupMenuItem(
                value: false,
                child: Text('Angin Tertinggi → Terendah'),
              ),
            ],
          ),
        ],
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
                  onChanged: weatherProv.setSearchQuery,
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Semua',
                      'Optimal',
                      'Waspada Angin',
                      'Favorit'
                    ].map((filter) {
                      final isSelected = weatherProv.selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor:
                              AppConstants.primaryMint.withValues(alpha: 0.2),
                          onSelected: (_) => weatherProv.setFilter(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: weatherProv.isLoading
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('Memuat data cuaca dari REST API...'),
                            ],
                          ),
                        )
                      : weatherProv.errorMessage != null &&
                              filteredSpots.isEmpty
                          ? StateStatusView(
                              icon: Icons.cloud_off,
                              title: 'Gagal Memuat Cuaca API',
                              message: weatherProv.errorMessage!,
                              actionLabel: 'Coba Lagi',
                              isError: true,
                              onAction: weatherProv.fetchLiveWeatherSpots,
                            )
                          : filteredSpots.isEmpty
                              ? StateStatusView(
                                  icon: Icons.travel_explore,
                                  title: 'Lokasi Tidak Ditemukan',
                                  message:
                                      'Tidak ada lokasi terbang yang cocok dengan filter "${weatherProv.selectedFilter}" atau kata kunci pencarianmu.',
                                  actionLabel: 'Reset Filter',
                                  onAction: () {
                                    weatherProv.setSearchQuery('');
                                    weatherProv.setFilter('Semua');
                                  },
                                )
                              : RefreshIndicator(
                                  onRefresh: weatherProv.fetchLiveWeatherSpots,
                                  child: isWide
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
                                            final spotMap =
                                                filteredSpots[index].toMap();
                                            return SpotCard(
                                              spot: spotMap,
                                              margin: EdgeInsets.zero,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        SpotDetailScreen(
                                                            spot: spotMap),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : ListView.builder(
                                          itemCount: filteredSpots.length,
                                          itemBuilder: (context, index) {
                                            final spotMap =
                                                filteredSpots[index].toMap();
                                            return SpotCard(
                                              spot: spotMap,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        SpotDetailScreen(
                                                            spot: spotMap),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
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