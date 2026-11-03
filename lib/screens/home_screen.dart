import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../widgets/section_header.dart';
import '../widgets/spot_card.dart';
import '../widgets/weather_stat_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const spots = AppConstants.flyingSpots;
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
              AppConstants.appSubtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.softMintBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.primaryMint.withValues(alpha: 0.4)),
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
                          children: _buildStatBadges(),
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildHeroBanner(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildStatBadges()[0]),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatBadges()[2]),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                const SectionHeader(
                  title: 'Rekomendasi Lokasi Terbang',
                  actionText: 'Lihat Semua',
                ),
                const SizedBox(height: 4),
                if (isWide)
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
                      return SpotCard(
                        spot: spots[index],
                        margin: EdgeInsets.zero,
                      );
                    },
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: spots.length,
                    itemBuilder: (context, index) {
                      return SpotCard(spot: spots[index]);
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
            'Kondisi Udara Hari Ini',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          SizedBox(height: 6),
          Text(
            'Singaraja & Bali Area: Aman untuk Uji Terbang Fixed-Wing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kecepatan angin rata-rata di bawah 15 km/h pada pagi hingga sore hari.',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatBadges() {
    return const [
      WeatherStatBadge(
        icon: Icons.air,
        label: 'Rata-rata Angin',
        value: '13.2 km/h',
        color: AppConstants.primaryMint,
      ),
      SizedBox(height: 12),
      WeatherStatBadge(
        icon: Icons.explore_outlined,
        label: 'Spot Terpantau',
        value: '4 Lokasi',
        color: AppConstants.accentPeach,
      ),
    ];
  }
}