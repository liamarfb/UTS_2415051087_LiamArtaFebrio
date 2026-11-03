import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../models/flying_spot.dart';
import '../repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;

  List<FlyingSpot> _spots = [];
  final Set<String> _favoriteSpotIds = {'spot_1'};
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  WeatherProvider({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository() {
    fetchLiveWeatherSpots();
  }

  List<FlyingSpot> get spots => _spots;
  Set<String> get favoriteSpotIds => _favoriteSpotIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

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

  double get averageWindSpeed {
    if (_spots.isEmpty) return 0.0;
    final total = _spots.fold<double>(0.0, (sum, item) => sum + item.windSpeed);
    return double.parse((total / _spots.length).toStringAsFixed(1));
  }

  // Mengambil data cuaca real-time dari Open-Meteo REST API via Repository
  Future<void> fetchLiveWeatherSpots() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final liveSpots = await _repository.getLiveFlyingSpots();
      _spots = liveSpots;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      // Jika sedang belum ada data sama sekali, sediakan fallback awal agar tetap aman
      if (_spots.isEmpty) {
        _spots = AppConstants.flyingSpots
            .map((item) => FlyingSpot.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
}