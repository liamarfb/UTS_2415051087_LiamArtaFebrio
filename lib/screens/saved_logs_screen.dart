import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../models/flight_log.dart';
import '../providers/flight_log_provider.dart';
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'NIM: 2415051087 • Pendidikan Teknik Informatika',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
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
          ),
          const SizedBox(height: 20),
          const Text(
            'Catatan Uji Terbang Tersimpan',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (logProv.isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (logs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text('Belum ada catatan terbang di database.'),
              ),
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
                  title: Text(
                    log.aircraft,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      '${log.spotName} • ${log.durationMinutes} menit • Rating ${log.rating}/5\n${log.notes}',
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
      ),
    );
  }
}