class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final int marketCapRank;
  final double high24h;
  final double low24h;
  final double totalVolume;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
    required this.totalVolume,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      high24h: (json['high_24h'] ?? 0).toDouble(),
      low24h: (json['low_24h'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
    );
  }
}

class CoinDetail {
  final String id;
  final String symbol;
  final String name;
  final String description;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final int marketCapRank;
  final double high24h;
  final double low24h;
  final double totalVolume;
  final double circulatingSupply;
  final double? totalSupply;
  final double? ath;
  final double? atl;

  CoinDetail({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
    required this.totalVolume,
    required this.circulatingSupply,
    this.totalSupply,
    this.ath,
    this.atl,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    return CoinDetail(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      name: json['name'] ?? '',
      description: json['description']?['en'] ?? 'No description available',
      image: json['image']?['large'] ?? '',
      currentPrice: (json['market_data']?['current_price']?['usd'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['market_data']?['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_data']?['market_cap']?['usd'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      high24h: (json['market_data']?['high_24h']?['usd'] ?? 0).toDouble(),
      low24h: (json['market_data']?['low_24h']?['usd'] ?? 0).toDouble(),
      totalVolume: (json['market_data']?['total_volume']?['usd'] ?? 0).toDouble(),
      circulatingSupply: (json['market_data']?['circulating_supply'] ?? 0).toDouble(),
      totalSupply: json['market_data']?['total_supply']?.toDouble(),
      ath: json['market_data']?['ath']?['usd']?.toDouble(),
      atl: json['market_data']?['atl']?['usd']?.toDouble(),
    );
  }
}