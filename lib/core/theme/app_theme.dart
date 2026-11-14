import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Tema global (área de compras, clara, com barras escuras e dourado).
/// As telas de entrada, escuras, usam `AppColors.auth*`.
abstract final class AppTheme {
  static ThemeData get light {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnDark,
      secondary: AppColors.gold,
      onSecondary: AppColors.authBackground,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
    );

    final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    return ThemeData(
      useMaterial3: true,
      // Jost em todo texto que não define fonte (campos, menus, diálogos).
      fontFamily: AppTextStyles.sans,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppSizes.borderWidth,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.authBackground,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textOnDark,
        iconTheme: IconThemeData(color: AppColors.gold),
        actionsIconTheme: IconThemeData(color: AppColors.gold),
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + AppSpacing.xs,
        ),
        hintStyle: AppTextStyles.inputHint,
        labelStyle: AppTextStyles.caption,
        floatingLabelStyle: AppTextStyles.caption,
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(
          AppColors.gold,
          width: AppSizes.borderWidthFocus,
        ),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(
          AppColors.danger,
          width: AppSizes.borderWidthFocus,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnDark,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          textStyle: AppTextStyles.button,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.transparent,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.button,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.goldDark,
          textStyle: AppTextStyles.bodyStrong,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.gold,
        elevation: AppSizes.elevation,
        extendedTextStyle: AppTextStyles.button,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.surface
              : AppColors.hint,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.gold
              : AppColors.placeholder,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.gold
              : AppColors.border,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: AppTextStyles.sectionHeading,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.transparent,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.goldDark,
        titleTextStyle: AppTextStyles.bodyStrong,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.authBackground,
        contentTextStyle: AppTextStyles.inputOnDark,
        actionTextColor: AppColors.gold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: color,
        width: width ?? AppSizes.borderWidth,
      ),
    );
  }
}
