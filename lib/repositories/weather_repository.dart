import '../core/app_constants.dart';
import '../models/flying_spot.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _apiService;

  WeatherRepository({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService();

  Future<List<FlyingSpot>> getLiveFlyingSpots() async {
    final baseSpots = AppConstants.flyingSpots;

    final futures = baseSpots.map((spotMap) async {
      final map = Map<String, dynamic>.from(spotMap);
      final lat = (map['latitude'] as num).toDouble();
      final lon = (map['longitude'] as num).toDouble();

      final weatherJson = await _apiService.fetchCurrentWeather(
        latitude: lat,
        longitude: lon,
      );

      return FlyingSpot.fromWeatherJson(map, weatherJson);
    }).toList();

    return await Future.wait(futures);
  }
}