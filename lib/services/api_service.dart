import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

class ApiService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';

  // Fetch list of coins
  Future<List<Coin>> fetchCoins({int page = 1, int perPage = 50}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((coin) => Coin.fromJson(coin)).toList();
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch coin details
  Future<CoinDetail> fetchCoinDetail(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$coinId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return CoinDetail.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load coin details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch market chart data (for price trends)
  Future<List<double>> fetchMarketChart(String coinId, {int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coins/$coinId/market_chart?vs_currency=usd&days=$days'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> prices = data['prices'];
        return prices.map((price) => (price[1] as num).toDouble()).toList();
      } else {
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Search coins
  Future<List<Coin>> searchCoins(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?query=$query'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> coins = data['coins'];
        
        // Fetch full details for search results
        List<Coin> fullCoins = [];
        for (var coin in coins.take(10)) {
          try {
            final detailResponse = await http.get(
              Uri.parse('$baseUrl/coins/markets?vs_currency=usd&ids=${coin['id']}'),
            );
            if (detailResponse.statusCode == 200) {
              List<dynamic> coinData = json.decode(detailResponse.body);
              if (coinData.isNotEmpty) {
                fullCoins.add(Coin.fromJson(coinData[0]));
              }
            }
          } catch (e) {
            // Skip coins that fail to load
            continue;
          }
        }
        return fullCoins;
      } else {
        throw Exception('Failed to search coins');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}