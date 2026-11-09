import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../models/flight_log.dart';
import '../providers/flight_log_provider.dart';

class EditLogScreen extends StatefulWidget {
  final Map<String, dynamic> logData;

  const EditLogScreen({super.key, required this.logData});

  @override
  State<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends State<EditLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _spotController;
  late final TextEditingController _aircraftController;
  late final TextEditingController _durationController;
  late final TextEditingController _notesController;
  late int _selectedRating;

  @override
  void initState() {
    super.initState();
    _spotController = TextEditingController(
      text: widget.logData['spot']?.toString() ?? '',
    );
    _aircraftController = TextEditingController(
      text: widget.logData['aircraft']?.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.logData['duration']?.toString() ?? '10',
    );
    _notesController = TextEditingController(
      text: widget.logData['notes']?.toString() ?? '',
    );
    _selectedRating = (widget.logData['rating'] as num?)?.toInt() ?? 5;
  }

  @override
  void dispose() {
    _spotController.dispose();
    _aircraftController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FlightLogProvider>();
    final updatedLog = FlightLog(
      id: widget.logData['id']?.toString(),
      spotName: _spotController.text.trim(),
      aircraft: _aircraftController.text.trim(),
      durationMinutes: int.parse(_durationController.text.trim()),
      notes: _notesController.text.trim(),
      rating: _selectedRating,
      createdAt: DateTime.now(),
    );

    final success = await provider.updateLog(updatedLog);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan terbang berhasil diperbarui!'),
          backgroundColor: AppConstants.primaryMint,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memperbarui data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = context.watch<FlightLogProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Edit Catatan Terbang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _spotController,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi Terbang',
                      prefixIcon: Icon(Icons.place_outlined),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Lokasi wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _aircraftController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Wahana / Pesawat RC',
                      prefixIcon: Icon(Icons.airplanemode_active),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Nama pesawat wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Durasi Terbang (Menit)',
                      prefixIcon: Icon(Icons.timer_outlined),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Durasi wajib diisi';
                      }
                      final parsed = int.tryParse(val.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Masukkan angka menit lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rating Performa Terbang (1 - 5)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final score = index + 1;
                      final isSelected = _selectedRating == score;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text('$score ★'),
                          selected: isSelected,
                          selectedColor:
                              AppConstants.accentPeach.withValues(alpha: 0.25),
                          onSelected: (_) =>
                              setState(() => _selectedRating = score),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan Evaluasi',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Catatan evaluasi wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.primaryMint,
                      ),
                      onPressed: isUpdating ? null : _submitUpdate,
                      icon: isUpdating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        isUpdating ? 'Memperbarui...' : 'Perbarui Flight Log',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}