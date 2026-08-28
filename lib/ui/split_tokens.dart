import 'package:flutter/material.dart';

class SplitSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double section = 40;
}

class SplitRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}

class SplitPalette {
  static const lightBackground = Color(0xFFFAF9F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF3F1ED);
  static const lightBorder = Color(0xFFEAE6E0);
  static const lightText = Color(0xFF1C1B1A);
  static const lightTextSecondary = Color(0xFF75706A);
  static const lightTextMuted = Color(0xFFA6A19A);
  static const lightPrimary = Color(0xFFFF6B4A);
  static const lightPrimarySoft = Color(0xFFFFE3DA);
  static const lightSecondary = Color(0xFF7C6CF6);
  static const lightSecondarySoft = Color(0xFFEDE9FF);
  static const lightSuccess = Color(0xFF1FA36B);
  static const lightSuccessSoft = Color(0xFFDFF5EB);
  static const lightDanger = Color(0xFFE5484D);
  static const lightDangerSoft = Color(0xFFFCE4E4);
  static const lightWarning = Color(0xFFC98A1B);
  static const lightWarningSoft = Color(0xFFFBF0DA);

  static const darkBackground = Color(0xFF131215);
  static const darkSurface = Color(0xFF1D1C21);
  static const darkSurfaceAlt = Color(0xFF28272D);
  static const darkBorder = Color(0xFF35333B);
  static const darkText = Color(0xFFF5F3F1);
  static const darkTextSecondary = Color(0xFFAFABA6);
  static const darkTextMuted = Color(0xFF777473);
  static const darkPrimary = Color(0xFFFF7C5E);
  static const darkPrimarySoft = Color(0xFF3D2620);
  static const darkSecondary = Color(0xFF9C8CFF);
  static const darkSecondarySoft = Color(0xFF2B2748);
  static const darkSuccess = Color(0xFF3FC088);
  static const darkSuccessSoft = Color(0xFF1B3227);
  static const darkDanger = Color(0xFFFF7A7D);
  static const darkDangerSoft = Color(0xFF3A2323);
  static const darkWarning = Color(0xFFF3B94F);
  static const darkWarningSoft = Color(0xFF3A2E17);

  static const participantColors = <Color>[
    Color(0xFFFF6B4A),
    Color(0xFF7C6CF6),
    Color(0xFF1FA36B),
    Color(0xFFC98A1B),
    Color(0xFF3E8DF7),
    Color(0xFFE5488E),
    Color(0xFF2FB0A6),
    Color(0xFF9C6BFF),
    Color(0xFFFF8A3D),
    Color(0xFF5C7CFA),
  ];

  static Color participantColor(int seed) {
    return participantColors[seed.abs() % participantColors.length];
  }
}

class SplitColors extends ThemeExtension<SplitColors> {
  const SplitColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primarySoft,
    required this.secondary,
    required this.secondarySoft,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color primarySoft;
  final Color secondary;
  final Color secondarySoft;
  final Color success;
  final Color successSoft;
  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;

  static const light = SplitColors(
    background: SplitPalette.lightBackground,
    surface: SplitPalette.lightSurface,
    surfaceAlt: SplitPalette.lightSurfaceAlt,
    border: SplitPalette.lightBorder,
    textPrimary: SplitPalette.lightText,
    textSecondary: SplitPalette.lightTextSecondary,
    textMuted: SplitPalette.lightTextMuted,
    primary: SplitPalette.lightPrimary,
    primarySoft: SplitPalette.lightPrimarySoft,
    secondary: SplitPalette.lightSecondary,
    secondarySoft: SplitPalette.lightSecondarySoft,
    success: SplitPalette.lightSuccess,
    successSoft: SplitPalette.lightSuccessSoft,
    danger: SplitPalette.lightDanger,
    dangerSoft: SplitPalette.lightDangerSoft,
    warning: SplitPalette.lightWarning,
    warningSoft: SplitPalette.lightWarningSoft,
  );

  static const dark = SplitColors(
    background: SplitPalette.darkBackground,
    surface: SplitPalette.darkSurface,
    surfaceAlt: SplitPalette.darkSurfaceAlt,
    border: SplitPalette.darkBorder,
    textPrimary: SplitPalette.darkText,
    textSecondary: SplitPalette.darkTextSecondary,
    textMuted: SplitPalette.darkTextMuted,
    primary: SplitPalette.darkPrimary,
    primarySoft: SplitPalette.darkPrimarySoft,
    secondary: SplitPalette.darkSecondary,
    secondarySoft: SplitPalette.darkSecondarySoft,
    success: SplitPalette.darkSuccess,
    successSoft: SplitPalette.darkSuccessSoft,
    danger: SplitPalette.darkDanger,
    dangerSoft: SplitPalette.darkDangerSoft,
    warning: SplitPalette.darkWarning,
    warningSoft: SplitPalette.darkWarningSoft,
  );

  @override
  SplitColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? primary,
    Color? primarySoft,
    Color? secondary,
    Color? secondarySoft,
    Color? success,
    Color? successSoft,
    Color? danger,
    Color? dangerSoft,
    Color? warning,
    Color? warningSoft,
  }) {
    return SplitColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      secondary: secondary ?? this.secondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
    );
  }

  @override
  SplitColors lerp(ThemeExtension<SplitColors>? other, double t) {
    if (other is! SplitColors) return this;
    return SplitColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondarySoft: Color.lerp(secondarySoft, other.secondarySoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
    );
  }
}

extension SplitThemeColors on BuildContext {
  SplitColors get splitColors {
    return Theme.of(this).extension<SplitColors>() ??
        (Theme.of(this).brightness == Brightness.dark ? SplitColors.dark : SplitColors.light);
  }
}
