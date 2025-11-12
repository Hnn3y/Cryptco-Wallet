import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coin_provider.dart';
import '../widgets/coin_list_item.dart';
import 'coin_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              pinned: true,
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF9B8CFF), Color(0xFF6C5DD3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Crypto Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F3A).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF9B8CFF).withOpacity(0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9B8CFF).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: -5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search for coins...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF9B8CFF)),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<CoinProvider>().clearSearch();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                          onChanged: (value) {
                            context.read<CoinProvider>().searchCoins(value);
                          },
                        ),
                      ),
                    ),
                    
                    Container(
                      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F3A).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B8CFF), Color(0xFF6C5DD3)],
                          ),
                        ),
                        labelColor: const Color.fromARGB(255, 13, 52, 150),
                        tabs: const [
                          Tab(text: 'All Coins'),
                          Tab(text: 'Favorites'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        
        body: Container(
          decoration: const BoxDecoration(),
          child: Consumer<CoinProvider>(
            builder: (context, provider, _) {
              if (provider.isOffline) {
                return _buildOfflineState(provider);
              }

              if (provider.error != null && provider.coins.isEmpty) {
                return _buildErrorState(provider);
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildCoinList(context, provider, provider.coins),
                  _buildCoinList(context, provider, provider.favoriteCoins),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildOfflineState(CoinProvider provider) {
    return _buildCenteredState(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      subtitle: 'Please check your connection and try again.',
      onRetry: provider.fetchCoins,
    );
  }

  Widget _buildErrorState(CoinProvider provider) {
    return _buildCenteredState(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      subtitle: provider.error?.toString() ?? 'Unknown error occurred.',
      onRetry: provider.fetchCoins,
    );
  }

  Widget _buildCenteredState({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: const Color(0xFF9B8CFF).withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Web3 Style: Glowing Gradient Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5DD3).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ],
              gradient: const LinearGradient(
                colors: [Color(0xFF9B8CFF), Color(0xFF6C5DD3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinList(BuildContext context, CoinProvider provider, List coins) {
    if (provider.isLoading && coins.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C5DD3),
        ),
      );
    }

    if (coins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 16),
            const Text(
              'No coins found',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchCoins(),
      color: const Color(0xFF6C5DD3),
      backgroundColor: const Color(0xFF1A1F3A),
      child: ListView.builder(
        itemCount: coins.length,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        itemBuilder: (context, index) {
          final coin = coins[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12), // Spacing for card separation
            child: CoinListItem(
              coin: coin,
              isFavorite: provider.isFavorite(coin.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoinDetailScreen(coinId: coin.id),
                  ),
                );
              },
              onFavoriteToggle: () {
                provider.toggleFavorite(coin.id);
              },
            ),
          );
        },
      ),
    );
  }
}