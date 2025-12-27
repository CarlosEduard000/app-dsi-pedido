import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryCyan = Color(0xFF00B7D1);
  static const Color lightBlue   = Color(0xFF1B2C56);
  static const Color darkBlue    = Color(0xFFF8F9FA);
  static const Color darkGrey    = Color(0xFF9E9E9E);
  static const Color darkCarbon  = Color(0xFF424242);
  static const Color background  = Color(0xFFF8F9FA); 
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFF212121);
  static const Color error       = Color(0xFFFE2194);
}

class AppTheme {
  final bool isDarkmode;
  final int selectedColor;

  AppTheme({
    this.isDarkmode = false,
    this.selectedColor = 0,
  });

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: isDarkmode ? Brightness.dark : Brightness.light,
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryCyan,
      primary: AppColors.primaryCyan,
      secondary: isDarkmode ? AppColors.darkBlue : AppColors.lightBlue,
      onSecondary: isDarkmode ? AppColors.darkGrey : AppColors.darkCarbon,
      surface: isDarkmode ? AppColors.surfaceGrey : AppColors.surface,
      error: AppColors.error,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,      
    ),

    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: isDarkmode ? Colors.grey[900] : AppColors.surface,
      elevation: 0.5,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: isDarkmode ? Colors.white : const Color(0xFF333333)),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryCyan,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  AppTheme copyWith({
    bool? isDarkmode,
    int? selectedColor,
  }) => AppTheme(
    isDarkmode: isDarkmode ?? this.isDarkmode,
    selectedColor: selectedColor ?? this.selectedColor,
  );
}