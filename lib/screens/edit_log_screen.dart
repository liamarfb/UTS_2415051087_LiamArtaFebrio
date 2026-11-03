import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class EditLogScreen extends StatefulWidget {
  final Map<String, dynamic> logData;

  const EditLogScreen({super.key, required this.logData});

  @override
  State<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends State<EditLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _aircraftController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _aircraftController =
        TextEditingController(text: widget.logData['aircraft']?.toString() ?? '');
    _notesController =
        TextEditingController(text: widget.logData['notes']?.toString() ?? '');
  }

  @override
  void dispose() {
    _aircraftController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _aircraftController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Wahana / Pesawat RC',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Tidak boleh kosong' : null,
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
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.primaryMint,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Perubahan disimpan!')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Perbarui Log'),
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