import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../models/flying_spot.dart';

class WeatherProvider extends ChangeNotifier {
  List<FlyingSpot> _spots = [];
  final Set<String> _favoriteSpotIds = {'spot_1'};
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  WeatherProvider() {
    loadInitialSpots();
  }

  List<FlyingSpot> get spots => _spots;
  Set<String> get favoriteSpotIds => _favoriteSpotIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  // Mengambil daftar lokasi yang sudah difilter berdasarkan pencarian & chip status
  List<FlyingSpot> get filteredSpots {
    return _spots.where((spot) {
      final matchesSearch = spot.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          spot.region.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedFilter == 'Favorit') {
        return matchesSearch && _favoriteSpotIds.contains(spot.id);
      }
      final matchesFilter =
          _selectedFilter == 'Semua' || spot.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  // Menghitung rata-rata kecepatan angin secara dinamis untuk ditampilkan di Dashboard
  double get averageWindSpeed {
    if (_spots.isEmpty) return 0.0;
    final total = _spots.fold<double>(0.0, (sum, item) => sum + item.windSpeed);
    return double.parse((total / _spots.length).toStringAsFixed(1));
  }

  // Memuat data awal sebelum dihubungkan ke live REST API pada Tahap 8
  void loadInitialSpots() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _spots = AppConstants.flyingSpots
          .map((item) => FlyingSpot.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat data lokasi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shared State: Menambah/menghapus lokasi dari daftar Favorit
  void toggleFavorite(String spotId) {
    if (_favoriteSpotIds.contains(spotId)) {
      _favoriteSpotIds.remove(spotId);
    } else {
      _favoriteSpotIds.add(spotId);
    }
    notifyListeners();
  }

  bool isFavorite(String spotId) => _favoriteSpotIds.contains(spotId);

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Digunakan pada Tahap 8 saat mengintegrasikan REST API
  void updateSpotsFromApi(List<FlyingSpot> updatedSpots) {
    _spots = updatedSpots;
    _isLoading = false;
    _errorMessage = null;
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