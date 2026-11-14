import 'package:flutter/material.dart';

/// Paleta do Jô Modas, extraída do protótipo do Figma.
///
/// Identidade preta + dourada (entrada, cabeçalhos e destaques) sobre uma
/// área de compras clara; o vermelho fica para preço promocional e compra.
/// Nunca escreva cor "na mão" nas telas.
abstract final class AppColors {
  // Escuro da marca (entrada, cabeçalhos, resumo do carrinho)
  static const Color authBackground = Color(0xFF1E1B1B);
  static const Color authBackgroundDeep = Color(0xFF121010);
  static const Color authCard = Color(0xFF2B2727);
  static const Color authField = Color(0xFF3A3535);
  static const Color errorOnDark = Color(0xFFFFB4AB);

  // Dourado metálico
  static const Color goldLight = Color(0xFFF1D27A);
  static const Color gold = Color(0xFFD4A94A);
  static const Color goldDark = Color(0xFF9C7524);
  static const Color goldSoft = Color(0xFFF6ECD3);
  static const Color goldBorder = Color(0x59D4A94A);

  /// Brilho atrás da logo na entrada: dourado bem escuro (opaco, para o
  /// degradê não formar anel).
  static const Color goldGlow = Color(0xFF3A2F1C);

  // Loja
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8E2D8);
  static const Color placeholder = Color(0xFFF1ECE4);
  static const Color primary = Color(0xFF111111);
  static const Color accent = Color(0xFFD32F2F);
  static const Color accentSoft = Color(0xFFFDECEC);
  static const Color shadow = Color(0x1F000000);
  static const Color shadowSoft = Color(0x12000000);
  static const Color imageOverlay = Color(0xCC000000);
  static const Color transparent = Color(0x00000000);

  // Texto
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B6560);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xB3FFFFFF);
  static const Color hint = Color(0xFFB0A89E);

  static const Color danger = Color(0xFFD32F2F);
}
