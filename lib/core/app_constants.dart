import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'AeroLog';
  static const String appSubtitle = 'RC Flight Weather & Logbook';

  static const Color primaryMint = Color(0xFF2EC4B6);
  static const Color softMintBg = Color(0xFFEBFDFB);
  static const Color accentPeach = Color(0xFFFF9F1C);
  static const Color softPeach = Color(0xFFFFBF69);

  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String supabaseUrl = 'https://yelxlykemozlslreswmi.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_HRiwbkDlOAzg1CMMOgJVjg_mlinGGYN';
  static const String flightLogsTable = 'flight_logs';

  static const flyingSpots = [
    {
      'id': 'spot_1',
      'name': 'Lapangan Bhuana Patra',
      'region': 'Singaraja, Buleleng',
      'latitude': -8.1167,
      'longitude': 115.0882,
      'terrain': 'Lapangan Rumput Terbuka',
      'recommendedWing': 'Trainer / High-Wing / Parkflyer',
      'windSpeed': 11.5,
      'temp': 29.0,
      'status': 'Optimal',
    },
    {
      'id': 'spot_2',
      'name': 'Pantai Penimbangan Coastal',
      'region': 'Singaraja, Buleleng',
      'latitude': -8.1035,
      'longitude': 115.0664,
      'terrain': 'Pesisir Pantai (Angin Laut)',
      'recommendedWing': 'Slope Soarer / Fast Glider',
      'windSpeed': 19.2,
      'temp': 30.5,
      'status': 'Waspada Angin',
    },
    {
      'id': 'spot_3',
      'name': 'Pantai Mertasari Aero Zone',
      'region': 'Sanur, Denpasar Selatan',
      'latitude': -8.7077,
      'longitude': 115.2520,
      'terrain': 'Pesisir Pantai Luas',
      'recommendedWing': 'Fixed-Wing / Racing Plane / EDF',
      'windSpeed': 14.0,
      'temp': 31.0,
      'status': 'Optimal',
    },
    {
      'id': 'spot_4',
      'name': 'Danau Buyan Highland Strip',
      'region': 'Sukasada, Buleleng',
      'latitude': -8.2435,
      'longitude': 115.1258,
      'terrain': 'Dataran Tinggi / Lembah Danau',
      'recommendedWing': 'FPV Cruiser / High-Lift Wing',
      'windSpeed': 8.4,
      'temp': 22.5,
      'status': 'Optimal',
    },
  ];
}