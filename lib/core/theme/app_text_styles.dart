import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos de texto reutilizáveis. Tamanhos e pesos só existem aqui.
///
/// Duas fontes da marca (assets/fonts, declaradas no pubspec.yaml):
/// - [serif] Cormorant Garamond: só nos títulos grandes (toque editorial);
/// - [sans] Jost: todo o resto (seções, textos, botões e campos).
abstract final class AppTextStyles {
  static const String serif = 'CormorantGaramond';
  static const String sans = 'Jost';

  /// Título das telas de entrada ("Login", "Cadastre-se").
  static const TextStyle authTitle = TextStyle(
    fontFamily: serif,
    fontSize: 38,
    fontWeight: FontWeight.w500,
    height: 1.05,
    color: AppColors.textPrimary,
  );

  static const TextStyle authSubtitle = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  /// Nome do produto na tela de detalhes.
  static const TextStyle productName = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: sans,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Título de seção ("Categorias", "Veja também").
  static const TextStyle sectionHeading = TextStyle(
    fontFamily: sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: sans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    height: 1.55,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  /// Rótulo acima dos campos e dos grupos de opção.
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Rótulo pequeno em caixa alta ("COR", "DESTAQUE").
  static const TextStyle overline = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.6,
    color: AppColors.textSecondary,
  );

  static const TextStyle input = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: sans,
    fontSize: 14,
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

  static const TextStyle error = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    color: AppColors.danger,
  );

  static const TextStyle link = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle linkStrong = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.textPrimary,
  );

  static const TextStyle price = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceHighlight = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static const TextStyle priceStrike = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    color: AppColors.hint,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.hint,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceLargeHighlight = TextStyle(
    fontFamily: sans,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static const TextStyle priceLargeStrike = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    color: AppColors.hint,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.hint,
  );

  /// Total do resumo do carrinho.
  static const TextStyle total = TextStyle(
    fontFamily: sans,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle summaryLabel = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    color: AppColors.textOnDark,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: sans,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.textOnDark,
  );

  static const TextStyle snackBar = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    color: AppColors.textOnDark,
  );

  static const TextStyle bannerTag = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 2,
    color: AppColors.textOnDarkMuted,
  );

  static const TextStyle bannerName = TextStyle(
    fontFamily: serif,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.05,
    color: AppColors.textOnDark,
  );

  static const TextStyle bannerCta = TextStyle(
    fontFamily: sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: AppColors.textOnDark,
  );

  static const TextStyle statValue = TextStyle(
    fontFamily: sans,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
