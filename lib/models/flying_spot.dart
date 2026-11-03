class FlyingSpot {
  final String id;
  final String name;
  final String region;
  final double latitude;
  final double longitude;
  final String terrain;
  final String recommendedWing;
  final double windSpeed;
  final double temperature;
  final int windDirection;
  final String status;

  const FlyingSpot({
    required this.id,
    required this.name,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.terrain,
    required this.recommendedWing,
    required this.windSpeed,
    required this.temperature,
    this.windDirection = 0,
    required this.status,
  });

  // Mengonversi Map statis / lokal menjadi objek FlyingSpot
  factory FlyingSpot.fromMap(Map<String, dynamic> map) {
    final wind = (map['windSpeed'] as num?)?.toDouble() ?? 0.0;
    return FlyingSpot(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      region: map['region']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      terrain: map['terrain']?.toString() ?? '',
      recommendedWing: map['recommendedWing']?.toString() ?? '',
      windSpeed: wind,
      temperature: (map['temp'] as num?)?.toDouble() ?? 0.0,
      windDirection: (map['windDirection'] as num?)?.toInt() ?? 180,
      status: map['status']?.toString() ?? (wind < 16.0 ? 'Optimal' : 'Waspada Angin'),
    );
  }

  // Menggabungkan data lokasi dengan JSON response dari REST API Open-Meteo
  factory FlyingSpot.fromWeatherJson(
    Map<String, dynamic> spotBase,
    Map<String, dynamic> weatherJson,
  ) {
    final current = weatherJson['current'] as Map<String, dynamic>? ?? {};
    final double wind = (current['wind_speed_10m'] as num?)?.toDouble() ??
        (spotBase['windSpeed'] as num?)?.toDouble() ??
        0.0;
    final double temp = (current['temperature_2m'] as num?)?.toDouble() ??
        (spotBase['temp'] as num?)?.toDouble() ??
        28.0;
    final int dir = (current['wind_direction_10m'] as num?)?.toInt() ?? 180;

    return FlyingSpot(
      id: spotBase['id']?.toString() ?? '',
      name: spotBase['name']?.toString() ?? '',
      region: spotBase['region']?.toString() ?? '',
      latitude: (spotBase['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (spotBase['longitude'] as num?)?.toDouble() ?? 0.0,
      terrain: spotBase['terrain']?.toString() ?? '',
      recommendedWing: spotBase['recommendedWing']?.toString() ?? '',
      windSpeed: wind,
      temperature: temp,
      windDirection: dir,
      status: wind < 16.0 ? 'Optimal' : 'Waspada Angin',
    );
  }

  // Mengembalikan ke bentuk Map agar kompatibel dengan widget UI yang sudah ada
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'terrain': terrain,
      'recommendedWing': recommendedWing,
      'windSpeed': windSpeed,
      'temp': temperature,
      'windDirection': windDirection,
      'status': status,
    };
  }
}