import 'package:flutter/material.dart';
import '../models/flight_log.dart';
import '../repositories/flight_log_repository.dart';

class FlightLogProvider extends ChangeNotifier {
  final FlightLogRepository _repository;

  List<FlightLog> _logs = [
    FlightLog(
      id: '1',
      spotName: 'Lapangan Bhuana Patra',
      aircraft: 'Fixed-Wing Racing 6S (Prop 10x10)',
      durationMinutes: 10,
      notes: 'Takeoff mulus, arus puncak stabil, angin tenang.',
      rating: 5,
      createdAt: DateTime(2026, 11, 1, 8, 30),
    ),
    FlightLog(
      id: '2',
      spotName: 'Pantai Penimbangan Coastal',
      aircraft: 'Slope Soarer Wing',
      durationMinutes: 18,
      notes: 'Uji ketahanan angin pantai sore hari, trim elevator aman.',
      rating: 4,
      createdAt: DateTime(2026, 11, 2, 16, 45),
    ),
  ];

  bool _isLoading = false;
  String? _errorMessage;

  FlightLogProvider({FlightLogRepository? repository})
      : _repository = repository ?? FlightLogRepository() {
    fetchLogs();
  }

  List<FlightLog> get logs => List.unmodifiable(_logs);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSupabaseActive => _repository.isDatabaseReady;

  // Operasi READ Database
  Future<void> fetchLogs() async {
    if (!_repository.isDatabaseReady) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logs = await _repository.getFlightLogs();
    } catch (e) {
      _errorMessage = 'Gagal memuat database: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Operasi CREATE Database (Tahap 10)
  Future<bool> createLog(FlightLog newLog) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_repository.isDatabaseReady) {
        final created = await _repository.createFlightLog(newLog);
        _logs.insert(0, created);
      } else {
        await Future.delayed(const Duration(milliseconds: 300));
        _logs.insert(
          0,
          newLog.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
        );
      }
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan Flight Log: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Operasi UPDATE Database (Tahap 11)
  Future<bool> updateLog(FlightLog updatedLog) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FlightLog resultLog = updatedLog;
      if (_repository.isDatabaseReady) {
        resultLog = await _repository.updateFlightLog(updatedLog);
      } else {
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final index = _logs.indexWhere((item) => item.id == updatedLog.id);
      if (index != -1) {
        _logs[index] = resultLog;
      }
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui Flight Log: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteLocalLog(String id) {
    _logs.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}