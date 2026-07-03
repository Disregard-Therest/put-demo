import 'package:flutter/material.dart';

/// Палитра — премиальная тёмная с золотом (от макетов amelisoul-mockups).
abstract final class AppColors {
  static const deep = Color(0xFF07060F); // фон страницы презентации
  static const bg = Color(0xFF0E0B1A); // фон «телефона»
  static const card = Color(0xFF1B1533);
  static const card2 = Color(0xFF241A44);
  static const line = Color(0xFF2F2650);
  static const gold = Color(0xFFD9B26A);
  static const goldSoft = Color(0xFFE7CF9C);
  static const goldDeep = Color(0xFFB98F4A);
  static const text = Color(0xFFECE7F6);
  static const muted = Color(0xFF9B90BD);
  static const accent = Color(0xFF8A6BD6);
  static const accentDeep = Color(0xFF3A2A6E);
}

abstract final class AppGradients {
  static const goldCta = LinearGradient(
    colors: [AppColors.goldDeep, AppColors.goldSoft],
  );
  static const glowCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A1F4E), Color(0xFF1A1330)],
  );
  static const themeCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3A2A1E), Color(0xFF241A30)],
  );
  static const chartBar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.accent, AppColors.accentDeep],
  );
}

abstract final class AppText {
  static const display = TextStyle(
    fontFamily: 'Playfair',
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    height: 1.2,
  );
  static const eyebrow = TextStyle(
    fontSize: 10,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );
  static const body = TextStyle(fontSize: 14, height: 1.45, color: AppColors.text);
  static const muted = TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: AppColors.deep,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
      surface: AppColors.bg,
    ),
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.gold,
      selectionColor: Color(0x338A6BD6),
      selectionHandleColor: AppColors.gold,
    ),
  );
}
