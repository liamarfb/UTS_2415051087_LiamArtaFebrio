import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../providers/weather_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/spot_card.dart';
import '../widgets/weather_stat_badge.dart';
import 'spot_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, Map<String, dynamic> spot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SpotDetailScreen(spot: spot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final spots = weatherProv.spots;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWideScreen = screenWidth >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppConstants.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Live Open-Meteo REST API',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Data REST API',
            onPressed: weatherProv.isLoading
                ? null
                : () => weatherProv.fetchLiveWeatherSpots(),
            icon: const Icon(Icons.refresh, color: AppConstants.primaryMint),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.softMintBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppConstants.primaryMint.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(
                  isWideScreen ? Icons.tablet_mac : Icons.phone_android,
                  size: 14,
                  color: AppConstants.primaryMint,
                ),
                const SizedBox(width: 4),
                Text(
                  isWideScreen ? 'Wide Layout' : 'Compact Layout',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 600;
          final int gridColumns = constraints.maxWidth >= 950 ? 3 : 2;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 28.0 : 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildHeroBanner()),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: _buildStatBadges(weatherProv),
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildHeroBanner(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildStatBadges(weatherProv)[0]),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatBadges(weatherProv)[2]),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                if (weatherProv.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            weatherProv.errorMessage!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: weatherProv.fetchLiveWeatherSpots,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                const SectionHeader(
                  title: 'Cuaca Lokasi Terbang (Live API)',
                ),
                const SizedBox(height: 4),
                if (weatherProv.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.0),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Mengambil cuaca real-time dari Open-Meteo API...'),
                        ],
                      ),
                    ),
                  )
                else if (spots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text('Belum ada titik lokasi terbang tersedia.'),
                    ),
                  )
                else if (isWide)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: spots.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 156,
                    ),
                    itemBuilder: (context, index) {
                      final spotMap = spots[index].toMap();
                      return SpotCard(
                        spot: spotMap,
                        margin: EdgeInsets.zero,
                        onTap: () => _openDetail(context, spotMap),
                      );
                    },
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: spots.length,
                    itemBuilder: (context, index) {
                      final spotMap = spots[index].toMap();
                      return SpotCard(
                        spot: spotMap,
                        onTap: () => _openDetail(context, spotMap),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2EC4B6), Color(0xFF20A4F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kondisi Udara Real-Time (Open-Meteo API)',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          SizedBox(height: 6),
          Text(
            'Pantauan Angin & Suhu Lapangan Aeromodelling Bali',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Data diperbarui langsung melalui operasi HTTP GET dari satelit cuaca Open-Meteo.',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatBadges(WeatherProvider weatherProv) {
    return [
      WeatherStatBadge(
        icon: Icons.air,
        label: 'Rata-rata Angin',
        value: '${weatherProv.averageWindSpeed} km/h',
        color: AppConstants.primaryMint,
      ),
      const SizedBox(height: 12),
      WeatherStatBadge(
        icon: Icons.explore_outlined,
        label: 'Spot Terpantau',
        value: '${weatherProv.spots.length} Lokasi',
        color: AppConstants.accentPeach,
      ),
    ];
  }
}