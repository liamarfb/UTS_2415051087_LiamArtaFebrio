import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import 'add_log_screen.dart';

class SpotDetailScreen extends StatelessWidget {
  final Map<String, dynamic> spot;

  const SpotDetailScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    final bool isOptimal = spot['status'] == 'Optimal';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Lokasi Terbang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2EC4B6), Color(0xFF0F766E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          spot['status'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        spot['name'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            spot['region'].toString(),
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        Icons.air,
                        'Kecepatan Angin',
                        '${spot['windSpeed']} km/h',
                        AppConstants.primaryMint,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoTile(
                        Icons.thermostat,
                        'Suhu Udara',
                        '${spot['temp']}°C',
                        AppConstants.accentPeach,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spesifikasi Area & Rekomendasi Wahana',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Divider(height: 24),
                        _buildSpecRow('Karakteristik Medan', spot['terrain'].toString()),
                        const SizedBox(height: 12),
                        _buildSpecRow('Rekomendasi Pesawat', spot['recommendedWing'].toString()),
                        const SizedBox(height: 12),
                        _buildSpecRow(
                          'Koordinat GPS',
                          '${spot['latitude']}, ${spot['longitude']}',
                        ),
                        const SizedBox(height: 12),
                        _buildSpecRow(
                          'Rekomendasi Terbang',
                          isOptimal
                              ? 'Aman untuk penerbangan uji coba dan manuver.'
                              : 'Gunakan pesawat dengan wing loading lebih berat / kecepatan tinggi.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstants.primaryMint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddLogScreen(initialSpotName: spot['name'].toString()),
                        ),
                      );
                    },
                    icon: const Icon(Icons.note_add_outlined),
                    label: const Text(
                      'Catat Flight Log di Lokasi Ini',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }
}