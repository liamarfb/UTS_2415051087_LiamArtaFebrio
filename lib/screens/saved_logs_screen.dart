import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../models/flight_log.dart';
import '../providers/flight_log_provider.dart';
import '../widgets/state_status_view.dart';
import '../widgets/weather_stat_badge.dart';
import 'add_log_screen.dart';
import 'edit_log_screen.dart';

class SavedLogsScreen extends StatelessWidget {
  const SavedLogsScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, FlightLog log) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan Terbang?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus log "${log.aircraft}" di ${log.spotName}? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted && log.id != null) {
      final provider = context.read<FlightLogProvider>();
      final success = await provider.deleteLog(log.id!);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Catatan terbang berhasil dihapus.'
                : (provider.errorMessage ?? 'Gagal menghapus catatan.'),
          ),
          backgroundColor: success ? Colors.black87 : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logProv = context.watch<FlightLogProvider>();
    final logs = logProv.logs;
    final totalMinutes =
        logs.fold<int>(0, (sum, item) => sum + item.durationMinutes);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Flight Logbook & Pilot Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        actions: [
          IconButton(
            tooltip: 'Sinkronisasi Database',
            onPressed: logProv.isLoading ? null : () => logProv.fetchLogs(),
            icon: const Icon(Icons.sync, color: AppConstants.primaryMint),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryMint,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddLogScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Log'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 600;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 28.0 : 16.0,
              vertical: 16.0,
            ),
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildProfileCard(logProv)),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          WeatherStatBadge(
                            icon: Icons.timer_outlined,
                            label: 'Total Jam Terbang',
                            value: '$totalMinutes Menit',
                            color: AppConstants.primaryMint,
                          ),
                          const SizedBox(height: 12),
                          WeatherStatBadge(
                            icon: Icons.fact_check_outlined,
                            label: 'Total Sesi Log',
                            value: '${logs.length} Penerbangan',
                            color: AppConstants.accentPeach,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                _buildProfileCard(logProv),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: WeatherStatBadge(
                        icon: Icons.timer_outlined,
                        label: 'Total Terbang',
                        value: '$totalMinutes mnt',
                        color: AppConstants.primaryMint,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WeatherStatBadge(
                        icon: Icons.fact_check_outlined,
                        label: 'Sesi Log',
                        value: '${logs.length} Sesi',
                        color: AppConstants.accentPeach,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              if (logProv.errorMessage != null)
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
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          logProv.errorMessage!,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: logProv.fetchLogs,
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                ),
              const Text(
                'Catatan Uji Terbang Tersimpan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (logProv.isLoading)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memproses data Flight Log...'),
                      ],
                    ),
                  ),
                )
              else if (logs.isEmpty)
                StateStatusView(
                  icon: Icons.flight_land,
                  title: 'Belum Ada Catatan Terbang',
                  message:
                      'Logbook penerbangan RC kamu masih kosong. Mulai catat hasil uji terbang pertamamu!',
                  actionLabel: 'Tambah Flight Log Pertama',
                  onAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddLogScreen()),
                    );
                  },
                )
              else
                ...logs.map((log) {
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              log.aircraft,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppConstants.accentPeach
                                  .withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${log.rating} ★',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          '${log.spotName} • ${log.durationMinutes} menit • ${dateFormat.format(log.createdAt)}\n${log.notes}',
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit Log',
                            icon: const Icon(Icons.edit_outlined,
                                color: AppConstants.primaryMint),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditLogScreen(
                                    logData: {
                                      'id': log.id,
                                      'spot': log.spotName,
                                      'aircraft': log.aircraft,
                                      'duration': log.durationMinutes,
                                      'notes': log.notes,
                                      'rating': log.rating,
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: 'Hapus Log',
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, log),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(FlightLogProvider logProv) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppConstants.primaryMint,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Liam Arta Febrio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                const Text(
                  'NIM: 2415051087 • Pendidikan Teknik Informatika',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: logProv.isSupabaseActive
                        ? AppConstants.softMintBg
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    logProv.isSupabaseActive
                        ? 'Supabase PostgreSQL Connected'
                        : 'Local Mode (Siap Sinkron Supabase)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: logProv.isSupabaseActive
                          ? const Color(0xFF0F766E)
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}