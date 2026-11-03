class FlightLog {
  final String? id;
  final String spotName;
  final String aircraft;
  final int durationMinutes;
  final String notes;
  final int rating;
  final DateTime createdAt;

  const FlightLog({
    this.id,
    required this.spotName,
    required this.aircraft,
    required this.durationMinutes,
    required this.notes,
    this.rating = 5,
    required this.createdAt,
  });

  // Mengonversi JSON dari tabel Supabase menjadi objek FlightLog
  factory FlightLog.fromJson(Map<String, dynamic> json) {
    return FlightLog(
      id: json['id']?.toString(),
      spotName: json['spot_name']?.toString() ?? json['spot']?.toString() ?? '',
      aircraft: json['aircraft']?.toString() ?? '',
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ??
          (json['duration'] as num?)?.toInt() ??
          0,
      notes: json['notes']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Mengonversi objek FlightLog menjadi JSON untuk disimpan (INSERT/UPDATE) ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'spot_name': spotName,
      'aircraft': aircraft,
      'duration_minutes': durationMinutes,
      'notes': notes,
      'rating': rating,
    };
  }

  FlightLog copyWith({
    String? id,
    String? spotName,
    String? aircraft,
    int? durationMinutes,
    String? notes,
    int? rating,
    DateTime? createdAt,
  }) {
    return FlightLog(
      id: id ?? this.id,
      spotName: spotName ?? this.spotName,
      aircraft: aircraft ?? this.aircraft,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}