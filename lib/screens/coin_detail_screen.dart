import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/coin.dart';
import '../services/api_service.dart';
import '../widgets/price_chart.dart';
import '../utils/formatters.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  final ApiService _apiService = ApiService();
  CoinDetail? _coinDetail;
  List<double>? _chartData;
  bool _isLoading = true;
  String? _error;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await _apiService.fetchCoinDetail(widget.coinId);
      final chart = await _apiService.fetchMarketChart(widget.coinId, days: _selectedDays);
      
      setState(() {
        _coinDetail = detail;
        _chartData = chart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateChart(int days) async {
    setState(() => _selectedDays = days);
    try {
      final chart = await _apiService.fetchMarketChart(widget.coinId, days: days);
      setState(() => _chartData = chart);
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E27),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _coinDetail?.name ?? 'Loading...',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C5DD3)),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load details',
                        style: TextStyle(color: Colors.grey[400], fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5DD3),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: const Color(0xFF6C5DD3),
                  backgroundColor: const Color(0xFF1A1F3A),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildPriceSection(),
                        _buildChart(),
                        _buildStats(),
                        _buildDescription(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: _coinDetail!.image,
            width: 80,
            height: 80,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 16),
          Text(
            _coinDetail!.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _coinDetail!.symbol,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final isPositive = _coinDetail!.priceChangePercentage24h >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Text(
            Formatters.formatCurrency(_coinDetail!.currentPrice),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : ''}${_coinDetail!.priceChangePercentage24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Chart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeButton('24H', 1),
              _buildTimeButton('7D', 7),
              _buildTimeButton('30D', 30),
              _buildTimeButton('1Y', 365),
            ],
          ),
          const SizedBox(height: 16),
          if (_chartData != null)
            SizedBox(
              height: 200,
              child: PriceChart(
                data: _chartData!,
                color: _coinDetail!.priceChangePercentage24h >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String label, int days) {
    final isSelected = _selectedDays == days;
    return GestureDetector(
      onTap: () => _updateChart(days),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
       decoration: BoxDecoration(
  gradient: isSelected
      ? const LinearGradient(
          colors: [Color(0xFF8A2BE2), Color(0xFF00FFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : null,
  border: Border.all(color: Colors.white.withOpacity(0.2)),
  borderRadius: BorderRadius.circular(8),
  boxShadow: isSelected
      ? [
          BoxShadow(
            color: const Color(0xFF00FFFF).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ]
      : [],
),

        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1A1F3A), Color(0xFF121632)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.deepPurpleAccent.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.purpleAccent.withOpacity(0.2),
          blurRadius: 15,
          spreadRadius: -5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatRow('Market Cap', Formatters.formatCurrency(_coinDetail!.marketCap)),
        _buildStatRow('24h Volume', Formatters.formatCurrency(_coinDetail!.totalVolume)),
        _buildStatRow('24h High', Formatters.formatCurrency(_coinDetail!.high24h)),
        _buildStatRow('24h Low', Formatters.formatCurrency(_coinDetail!.low24h)),
        _buildStatRow('Rank', '#${_coinDetail!.marketCapRank}'),
        if (_coinDetail!.ath != null)
          _buildStatRow('All-Time High', Formatters.formatCurrency(_coinDetail!.ath!)),
      ],
    ),
  );
}


  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    if (_coinDetail!.description.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _coinDetail!.description.replaceAll(RegExp(r'<[^>]*>'), ''),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              height: 1.6,
            ),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}