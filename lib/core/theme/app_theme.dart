import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color navy = Color(0xFF0D1B2A);
  static const Color teal = Color(0xFF00B4A6);
  static const Color gold = Color(0xFFE8B923);
  static const Color surface = Color(0xFFF4F7FA);
  static const Color card = Colors.white;

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      primary: navy,
      secondary: teal,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        indicatorColor: teal.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? navy : Colors.grey.shade600,
          );
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: navy,
        unselectedLabelColor: Colors.grey,
        indicatorColor: teal,
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade200),
    );
  }

  /// High contrast / outdoor sun readability theme variant
  static ThemeData highContrast() {
    final base = light();
    return base.copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: base.colorScheme.copyWith(
        surface: Colors.white,
        onSurface: Colors.black,
        primary: Colors.black,
      ),
    );
  }
}
