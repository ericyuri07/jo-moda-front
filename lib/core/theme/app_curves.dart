import 'package:flutter/animation.dart';

/// Curvas de animação. Use sempre estas em vez de `Curves.*` direto.
abstract final class AppCurves {
  /// Entradas e trocas de estado: começa rápido e assenta suave.
  static const Curve standard = Curves.easeOutCubic;

  /// Movimentos de ida e volta (banner, indicador deslizante).
  static const Curve emphasized = Curves.easeInOutCubic;

  /// Pulsação do esqueleto de carregamento.
  static const Curve pulse = Curves.easeInOut;
}
