# CrypCo Wallet App 
A modern, feature-rich cryptocurrency wallet app built with Flutter that integrates with the CoinGecko API to display real-time crypto data.

## 📱 Features
✅ Real-time Crypto Data - Live prices, market cap, and 24h changes
✅ Interactive Charts - View price trends (24H, 7D, 30D, 1Y)
✅ Search Functionality - Quick search for any cryptocurrency
✅ Favorites System - Save your favorite coins for quick access
✅ Detailed Coin View - Comprehensive stats and information
✅ Offline Support - Graceful handling of network issues
✅ Pull to Refresh - Easy data updates
✅ Modern UI/UX - Beautiful Web3-inspired dark theme

## 🎥 Demo Video
Watch Demo Video Here


### 🛠️ Tech Stack
Framework: Flutter 3.9+
State Management: Provider
API: CoinGecko API
Charts: fl_chart
Networking: http
Storage: shared_preferences
Connectivity: connectivity_plus
Image Caching: cached_network_image
📂 Project Structure
lib/
├── main.dart                 # App entry point
├── models/
│   └── coin.dart            # Data models
├── services/
│   ├── api_service.dart     # API integration
│   └── storage_service.dart # Local storage
├── providers/
│   └── coin_provider.dart   # State management
├── screens/
│   ├── home_screen.dart     # Main screen
│   └── coin_detail_screen.dart # Detail view
├── widgets/
│   ├── coin_list_item.dart  # Coin list item
│   └── price_chart.dart     # Chart widget
└── utils/
    └── formatters.dart      # Formatting utilities
🚀 Getting Started
Prerequisites
Flutter SDK (3.9.2 or higher)
Dart SDK
Android Studio / VS Code
Android device or emulator
Installation
Clone the repository
bash
   git clone https://github.com/YOUR_USERNAME/crypto-wallet-app.git
   cd crypto-wallet-app
Install dependencies
bash
   flutter pub get
Run the app
bash
   flutter run
Building for Production
Android APK:

bash
flutter build apk --release
Android App Bundle:

bash
flutter build appbundle --release
The APK will be located at: build/app/outputs/flutter-apk/app-release.apk

🌐 API Integration
This app uses the CoinGecko API (free tier):

Base URL: https://api.coingecko.com/api/v3
No API key required for basic usage
Rate limit: 50 calls/minute
Key Endpoints Used:
/coins/markets - List of coins with market data
/coins/{id} - Detailed coin information
/coins/{id}/market_chart - Historical price data
/search - Search functionality
📱 App Screens
Home Screen
Displays list of top cryptocurrencies
Real-time price updates
Search bar for finding specific coins
Favorites tab for saved coins
Pull-to-refresh functionality
Coin Detail Screen
Large coin icon and current price
24h price change percentage
Interactive price chart with multiple timeframes
Detailed statistics (market cap, volume, high/low, rank)
Coin description
🎨 Design Features
Dark Theme - Modern Web3-inspired UI
Smooth Animations - Polished user experience
Responsive Layout - Works on all screen sizes
Loading States - Clear feedback during data fetching
Error Handling - User-friendly error messages
Offline Detection - Clear offline indicators
🔧 Error Handling
The app handles various error scenarios:

❌ No internet connection
❌ API request failures
❌ Timeout errors
❌ Empty states
❌ Invalid data
🧪 Testing
To run tests:

bash
flutter test
📝 Code Quality
Clear folder structure
Consistent naming conventions
Separated concerns (models, services, providers, UI)
Documented code
Error handling throughout
🚦 Future Enhancements
 Portfolio tracking
 Price alerts
 Multiple currency support
 News integration
 Advanced filtering options
 Theme customization
👨‍💻 Developer
Your Name

GitHub: @your-github-username
Email: your.email@example.com
📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
CoinGecko API for cryptocurrency data
Flutter community for amazing packages
Design inspiration from Dribbble and Behance
Built with ❤️ using Flutter

