import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/coin_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoinProvider(),
      child: MaterialApp(
        title: 'Crypto Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,

          // Primary Web3 gradient tones
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF8A2BE2), // Electric purple
            secondary: Color(0xFF00FFFF), // Neon cyan
            surface: Color(0xFF121212),
            background: Color(0xFF0A0F1E),
          ),

          scaffoldBackgroundColor: const Color(0xFF0A0F1E),

          // ✅ Use GoogleFonts here (non-const)
          textTheme: TextTheme(
            headlineMedium: GoogleFonts.orbitron(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            bodyMedium: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),

          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            titleTextStyle: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
      cardTheme: const CardThemeData(
  color: Color(0xFF1A1F3A),
  surfaceTintColor: Colors.transparent, // optional: removes M3 overlay tint
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  elevation: 8,
  shadowColor: Colors.deepPurpleAccent,
),
          // Neon accent buttons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: const Color(0xFF00FFFF),
              elevation: 10,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
