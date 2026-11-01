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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.flight_takeoff, color: AppConstants.primaryMint),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
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
                SizedBox(height: 4),
                Text(
                  'Singaraja & Bali Area: Aman untuk Uji Terbang Fixed-Wing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Kecepatan angin rata-rata di bawah 15 km/h pada pagi hingga sore hari.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: WeatherStatBadge(
                  icon: Icons.air,
                  label: 'Rata-rata Angin',
                  value: '13.2 km/h',
                  color: AppConstants.primaryMint,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: WeatherStatBadge(
                  icon: Icons.explore_outlined,
                  label: 'Spot Terpantau',
                  value: '4 Lokasi',
                  color: AppConstants.accentPeach,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SectionHeader(
            title: 'Rekomendasi Lokasi Terbang',
            actionText: 'Lihat Semua',
          ),
          ...spots.map((spot) => SpotCard(spot: spot)),
        ],
      ),
    );
  }
}