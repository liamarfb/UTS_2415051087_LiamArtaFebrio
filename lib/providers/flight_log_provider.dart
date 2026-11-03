import 'package:flutter/material.dart';
import '../models/flight_log.dart';

class FlightLogProvider extends ChangeNotifier {
  final List<FlightLog> _logs = [
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

  List<FlightLog> get logs => List.unmodifiable(_logs);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void addLocalLog(FlightLog newLog) {
    _logs.insert(
      0,
      newLog.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    notifyListeners();
  }

  void updateLocalLog(FlightLog updatedLog) {
    final index = _logs.indexWhere((item) => item.id == updatedLog.id);
    if (index != -1) {
      _logs[index] = updatedLog;
      notifyListeners();
    }
  }

  void deleteLocalLog(String id) {
    _logs.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}