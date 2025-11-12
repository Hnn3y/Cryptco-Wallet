import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _favoritesKey = 'favorites';

  // Get favorites
  Future<List<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson != null) {
        List<dynamic> decoded = json.decode(favoritesJson);
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Add to favorites
  Future<bool> addFavorite(String coinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = await getFavorites();
      if (!favorites.contains(coinId)) {
        favorites.add(coinId);
        return await prefs.setString(_favoritesKey, json.encode(favorites));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFavorite(String coinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = await getFavorites();
      favorites.remove(coinId);
      return await prefs.setString(_favoritesKey, json.encode(favorites));
    } catch (e) {
      return false;
    }
  }

  // Check if coin is favorite
  Future<bool> isFavorite(String coinId) async {
    List<String> favorites = await getFavorites();
    return favorites.contains(coinId);
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String coinId) async {
    if (await isFavorite(coinId)) {
      return await removeFavorite(coinId);
    } else {
      return await addFavorite(coinId);
    }
  }
}