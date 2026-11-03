import 'package:flutter/material.dart';
import '../core/app_constants.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flight Log berhasil divalidasi!'),
          backgroundColor: AppConstants.primaryMint,
        ),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Lokasi wajib diisi' : null,
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
                      if (int.tryParse(val) == null) {
                        return 'Masukkan angka menit yang valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan Evaluasi Terbang',
                      hintText: 'Kondisi angin, kestabilan CG, atau performa propeler...',
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
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text(
                        'Simpan Flight Log',
                        style: TextStyle(fontWeight: FontWeight.bold),
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