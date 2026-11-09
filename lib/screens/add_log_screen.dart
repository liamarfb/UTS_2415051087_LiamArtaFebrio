import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_constants.dart';
import '../models/flight_log.dart';
import '../providers/flight_log_provider.dart';

class AddLogScreen extends StatefulWidget {
  final String? initialSpotName;

  const AddLogScreen({super.key, this.initialSpotName});

  @override
  State<AddLogScreen> createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _spotController;
  final _aircraftController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _spotController = TextEditingController(text: widget.initialSpotName ?? '');
  }

  @override
  void dispose() {
    _spotController.dispose();
    _aircraftController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FlightLogProvider>();
    final newLog = FlightLog(
      spotName: _spotController.text.trim(),
      aircraft: _aircraftController.text.trim(),
      durationMinutes: int.parse(_durationController.text.trim()),
      notes: _notesController.text.trim(),
      rating: _selectedRating,
      createdAt: DateTime.now(),
    );

    final success = await provider.createLog(newLog);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flight Log baru berhasil disimpan!'),
          backgroundColor: AppConstants.primaryMint,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal menyimpan data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<FlightLogProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Tambah Catatan Terbang',
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
                      hintText: 'Contoh: Lapangan Bhuana Patra',
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
                      labelText: 'Nama Wahana / Setup Pesawat RC',
                      hintText: 'Contoh: Fixed-Wing NACA 64-108 (6S LiPo)',
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
                      hintText: 'Contoh: 12',
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
                    'Rating Kelayakan & Performa Terbang (1 - 5)',
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
                      labelText: 'Catatan Evaluasi Terbang',
                      hintText:
                          'Kondisi angin, kestabilan CG, atau performa propeler...',
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
                      onPressed: isSaving ? null : _submitForm,
                      icon: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        isSaving ? 'Menyimpan...' : 'Simpan Flight Log',
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