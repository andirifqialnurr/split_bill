import 'package:flutter/material.dart';

import 'split_tokens.dart';

class SplitTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: SplitPalette.lightPrimary,
      brightness: Brightness.light,
      primary: SplitPalette.lightPrimary,
      secondary: SplitPalette.lightSecondary,
      tertiary: SplitPalette.lightAccent,
      surface: SplitPalette.lightSurface,
    );
    return _build(
      scheme.copyWith(
        surfaceContainerHighest: SplitPalette.lightSurfaceElevated,
        outline: SplitPalette.lightBorder,
      ),
      SplitPalette.lightBackground,
      SplitPalette.lightText,
      SplitPalette.lightTextMuted,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: SplitPalette.darkPrimary,
      brightness: Brightness.dark,
      primary: SplitPalette.darkPrimary,
      secondary: SplitPalette.darkSecondary,
      tertiary: SplitPalette.darkAccent,
      surface: SplitPalette.darkSurface,
    );
    return _build(
      scheme.copyWith(
        surfaceContainerHighest: SplitPalette.darkSurfaceElevated,
        outline: SplitPalette.darkBorder,
      ),
      SplitPalette.darkBackground,
      SplitPalette.darkText,
      SplitPalette.darkTextMuted,
    );
  }

  static ThemeData _build(
    ColorScheme scheme,
    Color background,
    Color text,
    Color textMuted,
  ) {
    final textTheme = Typography.material2021().black.apply(
      bodyColor: text,
      displayColor: text,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      textTheme: textTheme.copyWith(
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          letterSpacing: 0,
          color: textMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SplitRadius.lg),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.72)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SplitRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SplitRadius.md),
          ),
        ),
      ),
    );
  }
}
