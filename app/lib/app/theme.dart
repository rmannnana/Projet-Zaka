import 'package:flutter/material.dart';

/// Couleurs de marque ZAKA : vert sapin, doré, fonds clairs et teintes douces.
abstract final class ZakaColors {
  static const brand = Color(0xFF0B4A3C);
  static const brandDark = Color(0xFF073428);
  static const accent = Color(0xFFE6AD5E);
  static const heart = Color(0xFFEA3A47);
  static const ink = Color(0xFF16211F);
}

/// Teintes complémentaires du thème (tuiles de catégories, cœur, doré…),
/// déclinées en clair et en sombre.
@immutable
class ZakaPalette extends ThemeExtension<ZakaPalette> {
  const ZakaPalette({
    required this.gold,
    required this.onGold,
    required this.heart,
    required this.muted,
    required this.line,
    required this.shadow,
    required this.peach,
    required this.onPeach,
    required this.sage,
    required this.onSage,
    required this.lavender,
    required this.onLavender,
    required this.mint,
    required this.onMint,
    required this.sky,
    required this.onSky,
  });

  final Color gold;
  final Color onGold;
  final Color heart;

  /// Texte secondaire (lieux, dates, aides).
  final Color muted;

  /// Bordures fines des cartes et des champs.
  final Color line;
  final Color shadow;
  final Color peach;
  final Color onPeach;
  final Color sage;
  final Color onSage;
  final Color lavender;
  final Color onLavender;
  final Color mint;
  final Color onMint;
  final Color sky;
  final Color onSky;

  static const light = ZakaPalette(
    gold: ZakaColors.accent,
    onGold: Color(0xFF2B1D05),
    heart: ZakaColors.heart,
    muted: Color(0xFF6B7673),
    line: Color(0xFFE5E9E7),
    shadow: Color(0x140B2A22),
    peach: Color(0xFFFBEFE0),
    onPeach: Color(0xFFB0721A),
    sage: Color(0xFFEAF4EC),
    onSage: Color(0xFF2E7D4F),
    lavender: Color(0xFFF0EDFB),
    onLavender: Color(0xFF5B4BB7),
    mint: Color(0xFFE4F2EE),
    onMint: Color(0xFF0B6B5A),
    sky: Color(0xFFE8F1FB),
    onSky: Color(0xFF2563A6),
  );

  static const dark = ZakaPalette(
    gold: Color(0xFFF0C07A),
    onGold: Color(0xFF2B1D05),
    heart: Color(0xFFFF6B75),
    muted: Color(0xFFA3AFAB),
    line: Color(0xFF2B3532),
    shadow: Color(0x33000000),
    peach: Color(0xFF3A2E1E),
    onPeach: Color(0xFFF3C98C),
    sage: Color(0xFF1E3326),
    onSage: Color(0xFF8FD8A8),
    lavender: Color(0xFF2A2640),
    onLavender: Color(0xFFC3B8FF),
    mint: Color(0xFF17332D),
    onMint: Color(0xFF7FD1B5),
    sky: Color(0xFF1B2A3B),
    onSky: Color(0xFF9CC5F5),
  );

  static ZakaPalette of(BuildContext context) => Theme.of(context).extension<ZakaPalette>() ?? light;

  @override
  ZakaPalette copyWith() => this;

  @override
  ZakaPalette lerp(ZakaPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return ZakaPalette(
      gold: l(gold, other.gold),
      onGold: l(onGold, other.onGold),
      heart: l(heart, other.heart),
      muted: l(muted, other.muted),
      line: l(line, other.line),
      shadow: l(shadow, other.shadow),
      peach: l(peach, other.peach),
      onPeach: l(onPeach, other.onPeach),
      sage: l(sage, other.sage),
      onSage: l(onSage, other.onSage),
      lavender: l(lavender, other.lavender),
      onLavender: l(onLavender, other.onLavender),
      mint: l(mint, other.mint),
      onMint: l(onMint, other.onMint),
      sky: l(sky, other.sky),
      onSky: l(onSky, other.onSky),
    );
  }
}

/// Rayons d'arrondi communs.
abstract final class ZakaRadius {
  static const small = 10.0;
  static const medium = 14.0;
  static const card = 18.0;
  static const sheet = 26.0;
}

abstract final class ZakaTheme {
  static const fontFamily = 'PlusJakartaSans';

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ColorScheme _scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(seedColor: ZakaColors.brand, brightness: brightness);
    if (brightness == Brightness.light) {
      return base.copyWith(
        primary: ZakaColors.brand,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFE2EFEA),
        onPrimaryContainer: ZakaColors.brand,
        secondary: ZakaColors.accent,
        onSecondary: const Color(0xFF2B1D05),
        secondaryContainer: const Color(0xFFFBEFE0),
        onSecondaryContainer: const Color(0xFF6B4A12),
        surface: const Color(0xFFF6F7F6),
        onSurface: ZakaColors.ink,
        onSurfaceVariant: const Color(0xFF5F6B68),
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Colors.white,
        surfaceContainer: const Color(0xFFF0F2F1),
        surfaceContainerHigh: const Color(0xFFECEFED),
        surfaceContainerHighest: const Color(0xFFE6EAE8),
        outline: const Color(0xFF8A9592),
        outlineVariant: const Color(0xFFE3E8E6),
        error: const Color(0xFFC93A3A),
        surfaceTint: Colors.transparent,
      );
    }
    return base.copyWith(
      primary: const Color(0xFF7FD1B5),
      onPrimary: const Color(0xFF00382B),
      primaryContainer: const Color(0xFF0E5443),
      onPrimaryContainer: const Color(0xFFBDEFD9),
      secondary: const Color(0xFFF0C07A),
      onSecondary: const Color(0xFF2B1D05),
      secondaryContainer: const Color(0xFF3A2E1E),
      onSecondaryContainer: const Color(0xFFF3C98C),
      surface: const Color(0xFF0F1513),
      onSurface: const Color(0xFFE3EAE7),
      onSurfaceVariant: const Color(0xFFA7B3AF),
      surfaceContainerLowest: const Color(0xFF0B100F),
      surfaceContainerLow: const Color(0xFF161D1B),
      surfaceContainer: const Color(0xFF1A2220),
      surfaceContainerHigh: const Color(0xFF1F2826),
      surfaceContainerHighest: const Color(0xFF26302D),
      outline: const Color(0xFF6E7A77),
      outlineVariant: const Color(0xFF2C3633),
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final scheme = _scheme(brightness);
    final palette = brightness == Brightness.light ? ZakaPalette.light : ZakaPalette.dark;
    final card = scheme.surfaceContainerLow;
    final base = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
      visualDensity: VisualDensity.standard,
    );
    final text = base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.2),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: base.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.45),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
      bodySmall: base.textTheme.bodySmall?.copyWith(color: palette.muted, height: 1.4),
      labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      labelMedium: base.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium));
    const buttonText = TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 15);
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(ZakaRadius.medium),
      borderSide: BorderSide(color: color, width: width),
    );
    bool selected(Set<WidgetState> s) => s.contains(WidgetState.selected);

    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [palette],
      dividerTheme: DividerThemeData(color: palette.line, thickness: 1, space: 24),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: palette.shadow,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface, fontSize: 19),
      ),
      cardTheme: CardThemeData(
        color: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZakaRadius.card),
          side: BorderSide(color: palette.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: buttonShape,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: buttonShape,
          textStyle: buttonText,
          foregroundColor: scheme.primary,
          side: BorderSide(color: palette.line, width: 1.2),
          backgroundColor: card,
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: buttonText.copyWith(fontSize: 14),
          shape: buttonShape,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: buttonShape,
          textStyle: buttonText,
          elevation: 0,
          backgroundColor: card,
          foregroundColor: scheme.primary,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.small + 2)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.card)),
        extendedTextStyle: buttonText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: border(palette.line),
        enabledBorder: border(palette.line),
        focusedBorder: border(scheme.primary, 1.6),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 1.6),
        disabledBorder: border(palette.line.withValues(alpha: 0.5)),
        prefixIconColor: palette.muted,
        suffixIconColor: palette.muted,
        hintStyle: TextStyle(color: palette.muted, fontWeight: FontWeight.w400),
        labelStyle: TextStyle(color: palette.muted),
        floatingLabelStyle: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          border: border(palette.line),
          enabledBorder: border(palette.line),
          focusedBorder: border(scheme.primary, 1.6),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(card),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: StadiumBorder(side: BorderSide(color: palette.line)),
        side: WidgetStateBorderSide.resolveWith(
          (s) => BorderSide(color: selected(s) ? scheme.primary : palette.line),
        ),
        color: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.primary : card),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.onPrimary : scheme.onSurface),
        ),
        checkmarkColor: scheme.onPrimary,
        iconTheme: IconThemeData(color: scheme.primary, size: 18),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        showCheckmark: false,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.primary : card),
          foregroundColor: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.onPrimary : scheme.onSurface),
          iconColor: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.onPrimary : scheme.primary),
          side: WidgetStatePropertyAll(BorderSide(color: palette.line)),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
        shadowColor: palette.shadow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: selected(s) ? FontWeight.w700 : FontWeight.w500,
            color: selected(s) ? scheme.primary : palette.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: selected(s) ? scheme.primary : palette.muted, size: 24),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: card,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: palette.muted),
        selectedLabelTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: scheme.primary,
        ),
        unselectedLabelTextStyle: TextStyle(fontFamily: fontFamily, fontSize: 12, color: palette.muted),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: palette.muted,
        indicatorColor: scheme.primary,
        dividerColor: palette.line,
        labelStyle: const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(fontFamily: fontFamily, fontSize: 13, color: palette.muted, height: 1.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: palette.line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(ZakaRadius.sheet)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.sheet - 4)),
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.light ? ZakaColors.ink : scheme.surfaceContainerHighest,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: brightness == Brightness.light ? Colors.white : scheme.onSurface,
        ),
        actionTextColor: palette.gold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: palette.line,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateColor.resolveWith((s) => selected(s) ? Colors.white : palette.muted),
        trackColor: WidgetStateColor.resolveWith((s) => selected(s) ? scheme.primary : palette.line),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(color: palette.muted, width: 1.5),
      ),
      badgeTheme: BadgeThemeData(backgroundColor: palette.heart, textColor: Colors.white),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary, linearTrackColor: palette.line),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.sheet - 4)),
        rangeSelectionBackgroundColor: scheme.primaryContainer,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: scheme.primary,
      ),
    );
  }
}
