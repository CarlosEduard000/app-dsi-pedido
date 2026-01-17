import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryCyan = Color(0xFF01B4CF);
  static const Color darkBlue = Color(0xFF0A1F44);
  static const Color textGreyBlue = Color(0xFF525F7F);
  static const Color textGrey = Color(0xFF7C7C7C);
  static const Color textLightGrey = Color(0xFF8898AA);
  static const Color promotionPink = Color(0xFFF82C9C);
  static const Color statusPending = Color(0xFFEBBB1A);
  static const Color statusApproved = Color(0xFF00C853);
  static const Color statusStock = Color(0xFF009E4F);
  static const Color statusRejected = Color(0xFFFA4636);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF212121);
}

class AppTheme {
  final bool isDarkmode;
  final int selectedColor;

  AppTheme({this.isDarkmode = false, this.selectedColor = 0});

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryCyan,
      primary: AppColors.primaryCyan,
      onPrimary: AppColors.surfaceWhite,
      secondary: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
      onSecondary: isDarkmode ? AppColors.darkBlue : AppColors.surfaceWhite,
      tertiary: AppColors.promotionPink,
      onTertiary: AppColors.surfaceWhite,
      error: AppColors.statusRejected,
      onError: AppColors.surfaceWhite,
      surface: isDarkmode ? AppColors.surfaceDark : AppColors.surfaceWhite,
      onSurface: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
      onSurfaceVariant: isDarkmode
          ? AppColors.textLightGrey
          : AppColors.textGreyBlue,
      outline: AppColors.textLightGrey,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDarkmode
          ? Colors.black
          : AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isDarkmode
            ? AppColors.surfaceDark
            : AppColors.surfaceWhite,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
        ),
        titleTextStyle: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: isDarkmode ? AppColors.textLightGrey : AppColors.textGreyBlue,
        ),
        bodyLarge: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.textGreyBlue,
        ),
        bodyMedium: TextStyle(
          color: isDarkmode ? AppColors.textLightGrey : AppColors.textGreyBlue,
        ),
        bodySmall: TextStyle(
          color: isDarkmode ? AppColors.textGrey : AppColors.textGrey,
        ),
        labelLarge: TextStyle(
          color: isDarkmode ? AppColors.surfaceWhite : AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: isDarkmode ? AppColors.textLightGrey : AppColors.textLightGrey,
        ),
        labelSmall: TextStyle(
          color: isDarkmode ? AppColors.textGrey : AppColors.textLightGrey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCyan,
          foregroundColor: AppColors.surfaceWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textLightGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textLightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryCyan, width: 2),
        ),
        hintStyle: const TextStyle(color: AppColors.textLightGrey),
        labelStyle: TextStyle(
          color: isDarkmode ? AppColors.textLightGrey : AppColors.textGreyBlue,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkmode ? AppColors.surfaceWhite : AppColors.darkBlue,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.textLightGrey,
        thickness: 0.8,
      ),
    );
  }

  AppTheme copyWith({bool? isDarkmode, int? selectedColor}) => AppTheme(
    isDarkmode: isDarkmode ?? this.isDarkmode,
    selectedColor: selectedColor ?? this.selectedColor,
  );
}
