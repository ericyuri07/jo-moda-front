import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos de texto reutilizáveis. Tamanhos e pesos só existem aqui.
///
/// Duas fontes da marca (assets/fonts, declaradas no pubspec.yaml):
/// - [serif] Cormorant Garamond: títulos, serifa fina com toque feminino;
/// - [sans] Jost: textos, botões e campos.
abstract final class AppTextStyles {
  static const String serif = 'CormorantGaramond';
  static const String sans = 'Jost';

  /// Título dos cards de entrada ("Login", "Cadastre-se").
  static const TextStyle authTitle = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.textOnDark,
  );

  static const TextStyle authSubtitle = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    color: AppColors.textOnDarkMuted,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: serif,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: serif,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Nome do produto na tela de detalhes.
  static const TextStyle productName = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: sans,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Título de seção com traço dourado ("Categorias", "Veja também").
  static const TextStyle sectionHeading = TextStyle(
    fontFamily: serif,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Rótulo acima dos campos e dos grupos de opção.
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Rótulo pequeno em caixa alta ("COR", "DESTAQUE").
  static const TextStyle overline = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textSecondary,
  );

  static const TextStyle input = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputOnDark = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textOnDark,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    color: AppColors.hint,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle captionSmall = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    color: AppColors.textSecondary,
  );

  static const TextStyle link = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    color: AppColors.textOnDarkMuted,
  );

  static const TextStyle linkStrong = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
  );

  static const TextStyle errorOnDark = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    color: AppColors.errorOnDark,
  );

  static const TextStyle price = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceHighlight = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );

  static const TextStyle priceStrike = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: sans,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceLargeHighlight = TextStyle(
    fontFamily: sans,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.accent,
  );

  static const TextStyle priceLargeStrike = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  /// Total do carrinho, em dourado sobre o card escuro.
  static const TextStyle totalOnDark = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.goldLight,
  );

  static const TextStyle summaryOnDark = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textOnDarkMuted,
  );

  static const TextStyle button = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: AppColors.textOnDark,
  );

  static const TextStyle goldButton = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.authBackground,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
  );

  static const TextStyle bannerName = TextStyle(
    fontFamily: serif,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.05,
    color: AppColors.textOnDark,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.goldDark,
  );
}
