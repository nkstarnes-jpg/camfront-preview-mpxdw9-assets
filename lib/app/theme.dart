import 'package:flutter/material.dart';

/// Dark forest Camfront theme — muted greens / browns with green accents.
class CamfrontTheme {
  CamfrontTheme._();

  static const Color forestGreen = Color(0xFF1B3D2F);
  static const Color moss = Color(0xFF2D5A3F);
  static const Color leaf = Color(0xFF4CAF50);
  static const Color bark = Color(0xFF3E2C1C);
  static const Color soil = Color(0xFF2A2118);
  static const Color canopy = Color(0xFF0F1F17);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: leaf,
      brightness: Brightness.dark,
      primary: leaf,
      secondary: const Color(0xFF8BC34A),
      surface: canopy,
      onSurface: const Color(0xFFE8F0E9),
    ).copyWith(
      surfaceContainerHighest: moss.withValues(alpha: 0.45),
      outline: moss,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: canopy,
      appBarTheme: AppBarTheme(
        backgroundColor: forestGreen,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: forestGreen,
        selectedItemColor: leaf,
        unselectedItemColor: scheme.onSurface.withValues(alpha: 0.55),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: moss.withValues(alpha: 0.5),
        selectedColor: leaf.withValues(alpha: 0.35),
        labelStyle: TextStyle(color: scheme.onSurface),
        side: BorderSide(color: moss),
      ),
      cardTheme: CardThemeData(
        color: soil.withValues(alpha: 0.85),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
