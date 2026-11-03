import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/app_constants.dart';

typedef JsonMap = Map<String, dynamic>;

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<JsonMap> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.weatherBaseUrl}?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m,wind_direction_10m&wind_speed_unit=kmh',
    );

    try {
      final response = await _client.get(uri).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as JsonMap;
      } else {
        throw Exception(
          'Gagal memuat cuaca dari server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Koneksi ke Weather REST API gagal: $e');
    }
  }
}