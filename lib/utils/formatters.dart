import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: value < 1 ? 6 : 2,
    );
    
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }
    
    return formatter.format(value);
  }

  static String formatPercentage(double value) {
    return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
  }

  static String formatNumber(double value) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }
}