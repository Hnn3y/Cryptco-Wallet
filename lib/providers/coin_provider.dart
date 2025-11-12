import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/coin.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CoinProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Coin> _coins = [];
  List<Coin> _filteredCoins = [];
  List<String> _favorites = [];
  bool _isLoading = false;
  bool _isOffline = false;
  String? _error;
  String _searchQuery = '';

  List<Coin> get coins => _searchQuery.isEmpty ? _coins : _filteredCoins;
  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  CoinProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadFavorites();
    await _checkConnectivity();
    await fetchCoins();
    
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult == ConnectivityResult.none;
    notifyListeners();
  }

  Future<void> fetchCoins() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _checkConnectivity();
      if (_isOffline) {
        _error = 'No internet connection';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _coins = await _apiService.fetchCoins();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCoins(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredCoins = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // First filter local coins
      _filteredCoins = _coins.where((coin) {
        return coin.name.toLowerCase().contains(query.toLowerCase()) ||
               coin.symbol.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // If no local results, search API
      if (_filteredCoins.isEmpty && !_isOffline) {
        _filteredCoins = await _apiService.searchCoins(query);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredCoins = [];
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(String coinId) async {
    await _storageService.toggleFavorite(coinId);
    await _loadFavorites();
  }

  bool isFavorite(String coinId) {
    return _favorites.contains(coinId);
  }

  List<Coin> get favoriteCoins {
    return _coins.where((coin) => _favorites.contains(coin.id)).toList();
  }
}