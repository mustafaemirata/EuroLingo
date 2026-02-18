import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color primary = Color(0xFFD4A647); 
  static const Color primaryLight = Color(0xFFE8C06A); 
  static const Color primaryDark = Color(0xFFB08930); 
  static const Color accent = Color(0xFFD4A647); 
  static const Color accentGreen = Color(0xFF5CB85C); 
  static const Color accentOrange = Color(0xFFD4A647); 
  static const Color errorRed = Color(0xFFE57373); 
  static const Color surface = Color(0xFF1A1A1D); 
  static const Color surfaceLight = Color(0xFF2A2A2E); 
  static const Color surfaceCard = Color(0xFF222226); 
  static const Color surfaceElevated = Color(0xFF2E2E33); 
  static const Color background = Color(0xFF101012); 
  static const Color textPrimary = Color(0xFFF0EDE5); 
  static const Color textSecondary = Color(0xFFA09A90); 
  static const Color textMuted = Color(0xFF5A5652); 

  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4A647), Color(0xFFB08930)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF252528), Color(0xFF1A1A1D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF5CB85C), Color(0xFF449D44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quizGradient = LinearGradient(
    colors: [Color(0xFFD4A647), Color(0xFFB08930)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  
  static List<LinearGradient> letterGradients = [
    const LinearGradient(
      colors: [Color(0xFF2A2520), Color(0xFF1E1B17)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF252A20), Color(0xFF1B1E17)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF20252A), Color(0xFF171B1E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF2A2025), Color(0xFF1E171B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF28241E), Color(0xFF1C1A16)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF1E2428), Color(0xFF161A1C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF282028), Color(0xFF1C161C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF26261E), Color(0xFF1A1A16)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  static LinearGradient getLetterGradient(int index) {
    return letterGradients[index % letterGradients.length];
  }

  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  
  static BoxDecoration glassmorphism({
    double opacity = 0.1,
    double borderRadius = 14,
    Color? color,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withValues(alpha: opacity * 0.5),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.05),
        width: 0.5,
      ),
    );
  }
}
