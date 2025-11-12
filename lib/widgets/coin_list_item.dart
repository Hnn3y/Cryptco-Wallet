import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/coin.dart';
import '../utils/formatters.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CoinListItem({
    super.key,
    required this.coin,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = coin.priceChangePercentage24h >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Web3 glassy card with gradient
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1A1F3A),
              Color(0xFF12162E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF6C5DD3).withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Coin Icon with glow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: coin.image,
                width: 48,
                height: 48,
                placeholder: (context, url) => const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF6C5DD3),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.grey,
                  size: 36,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Coin Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        coin.symbol.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${coin.marketCapRank}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatCurrency(coin.currentPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? Colors.greenAccent : Colors.redAccent,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${isPositive ? '+' : ''}${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            // Favorite Button
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? Colors.pinkAccent
                    : Colors.grey.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
