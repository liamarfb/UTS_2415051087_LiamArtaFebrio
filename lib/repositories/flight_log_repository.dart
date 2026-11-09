import '../models/flight_log.dart';
import '../services/flight_log_service.dart';

class FlightLogRepository {
  final FlightLogService _service;

  FlightLogRepository({FlightLogService? service})
      : _service = service ?? FlightLogService();

  bool get isDatabaseReady => _service.isConfigured;

  Future<List<FlightLog>> getFlightLogs() async {
    final rawList = await _service.fetchAllLogs();
    return rawList.map((row) => FlightLog.fromJson(row)).toList();
  }

  Future<FlightLog> createFlightLog(FlightLog log) async {
    final inserted = await _service.insertLog(log.toJson());
    return FlightLog.fromJson(inserted);
  }

  Future<FlightLog> updateFlightLog(FlightLog log) async {
    if (log.id == null) {
      throw Exception('ID Flight Log tidak ditemukan untuk diupdate.');
    }
    final updated = await _service.updateLog(log.id!, log.toJson());
    return FlightLog.fromJson(updated);
  }

  Future<void> deleteFlightLog(String id) async {
    await _service.deleteLog(id);
  }
}