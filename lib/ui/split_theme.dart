import 'package:flutter/material.dart';

import 'split_tokens.dart';

class SplitTheme {
  static ThemeData light() {
    return _build(
      colors: SplitColors.light,
      brightness: Brightness.light,
      onPrimary: Colors.white,
    );
  }

  static ThemeData dark() {
    return _build(
      colors: SplitColors.dark,
      brightness: Brightness.dark,
      onPrimary: const Color(0xFF1A0F0B),
    );
  }

  static ThemeData _build({
    required SplitColors colors,
    required Brightness brightness,
    required Color onPrimary,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
    ).copyWith(
      primary: colors.primary,
      onPrimary: onPrimary,
      secondary: colors.secondary,
      error: colors.danger,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surfaceAlt,
      outline: colors.border,
    );
    final textTheme = Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(
          bodyColor: colors.textPrimary,
          displayColor: colors.textPrimary,
          fontFamily: 'Plus Jakarta Sans',
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      textTheme: textTheme.copyWith(
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 13.5,
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SplitRadius.lg),
          side: BorderSide(color: colors.border),
        ),
      ),
      dividerColor: colors.border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SplitSpacing.lg,
          vertical: SplitSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: colors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SplitRadius.md),
          borderSide: BorderSide(color: colors.danger),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SplitRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SplitRadius.md),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.textPrimary,
        contentTextStyle: TextStyle(color: colors.surface),
      ),
    );
  }
}
