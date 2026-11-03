import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import 'add_log_screen.dart';
import 'edit_log_screen.dart';

class SavedLogsScreen extends StatelessWidget {
  const SavedLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyLogs = [
      {
        'id': '1',
        'spot': 'Lapangan Bhuana Patra',
        'aircraft': 'Fixed-Wing Racing 6S (Prop 10x10)',
        'duration': 10,
        'notes': 'Takeoff mulus, arus puncak stabil, angin tenang.',
      },
      {
        'id': '2',
        'spot': 'Pantai Penimbangan Coastal',
        'aircraft': 'Slope Soarer Wing',
        'duration': 18,
        'notes': 'Uji ketahanan angin pantai sore hari, trim elevator aman.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Flight Logbook & Pilot Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
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
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppConstants.primaryMint,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Liam Arta Febrio',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'NIM: 2415051087 • Pendidikan Teknik Informatika',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
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
          ...dummyLogs.map((log) {
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
                  log['aircraft'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    '${log['spot']} (${log['duration']} mnt)\n${log['notes']}',
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppConstants.primaryMint),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditLogScreen(logData: log),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}