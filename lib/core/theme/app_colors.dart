import 'package:flutter/material.dart';

/// Paleta do Jô Modas.
///
/// Base neutra e clara (off-white, branco e tinta preta), com bordas finas no
/// lugar de sombras. O dourado da logo aparece só em detalhes, e o vermelho
/// fica para preço promocional e ações destrutivas.
/// Nunca escreva cor "na mão" nas telas.
abstract final class AppColors {
  static const Color background = Color(0xFFF7F6F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0EEEA);
  static const Color border = Color(0xFFE6E3DD);
  static const Color placeholder = Color(0xFFECE9E3);
  static const Color skeleton = Color(0xFFE4E0D9);

  static const Color primary = Color(0xFF151515);
  static const Color gold = Color(0xFFB8954F);
  static const Color goldDark = Color(0xFF8A6D33);
  static const Color accent = Color(0xFFB3261E);
  static const Color accentSoft = Color(0xFFFBEAE8);

  static const Color shadowSoft = Color(0x0D000000);
  static const Color imageOverlay = Color(0x99000000);
  static const Color transparent = Color(0x00000000);

  /// Brilho que atravessa a logo na abertura.
  static const Color shine = Color(0xB3FFFFFF);

  static const Color textPrimary = Color(0xFF151515);
  static const Color textSecondary = Color(0xFF75716B);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xCCFFFFFF);
  static const Color hint = Color(0xFFA8A39B);

  static const Color danger = Color(0xFFB3261E);
}
