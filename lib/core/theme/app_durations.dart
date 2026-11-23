/// Durações das animações e transições da interface.
abstract final class AppDurations {
  static const Duration bannerAutoplay = Duration(seconds: 5);
  static const Duration bannerSlide = Duration(milliseconds: 600);
  static const Duration dotChange = Duration(milliseconds: 300);
  static const Duration selection = Duration(milliseconds: 220);

  /// Entrada dos elementos na tela (fade + leve subida).
  static const Duration entrance = Duration(milliseconds: 480);

  /// Atraso entre um item e o próximo numa entrada em sequência.
  static const Duration stagger = Duration(milliseconds: 60);

  /// Maior atraso de uma entrada em sequência (listas longas não esperam).
  static const Duration maxStagger = Duration(milliseconds: 420);

  /// "Afundar" do card ou botão ao ser tocado.
  static const Duration press = Duration(milliseconds: 120);

  /// Troca de conteúdo (carregando → lista, entrega → retirada).
  static const Duration switcher = Duration(milliseconds: 300);

  /// Foto aparecendo depois de baixada.
  static const Duration imageFade = Duration(milliseconds: 350);

  /// Meio ciclo da pulsação do esqueleto de carregamento.
  static const Duration skeletonPulse = Duration(milliseconds: 850);

  /// Abertura com a logo, do primeiro quadro até seguir para o login.
  static const Duration splash = Duration(milliseconds: 2600);
}
