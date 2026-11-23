/// Dimensões fixas de componentes e fatores das animações.
abstract final class AppSizes {
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 26;
  static const double iconXl = 32;
  static const double iconState = 44;

  static const double logoAuth = 120;
  static const double logoSplash = 168;
  static const double splashLineWidth = 56;

  /// Escala inicial da logo na abertura (cresce até 1).
  static const double splashStartScale = 0.86;

  /// Largura (fração da logo) da faixa de brilho da abertura.
  static const double splashShineWidth = 0.18;
  static const double logoDrawer = 64;
  static const double logoHeader = 42;

  static const double bannerHeight = 230;
  static const double bannerIndicator = 14;
  static const double bannerIndicatorActive = 28;
  static const double bannerIndicatorHeight = 2;
  static const double categoryAvatar = 64;
  static const double categoryWidth = 72;
  static const double categoryListHeight = 104;
  static const double productCardAspectRatio = 0.56;

  static const double galleryHeight = 440;
  static const double thumbSize = 58;
  static const double optionChipHeight = 40;
  static const double optionChipMinWidth = 48;
  static const double relatedCardWidth = 156;
  static const double relatedListHeight = 300;
  static const double stepperHeight = 52;
  static const double stepperWidth = 120;
  static const double stepperHeightCompact = 34;
  static const double stepperWidthCompact = 96;
  static const double primaryButtonHeight = 52;
  static const int lowStockLimit = 5;

  static const double cartImageWidth = 84;
  static const double cartImageHeight = 108;
  static const double toggleHeight = 46;

  static const double adminThumb = 64;
  static const double stockFieldWidth = 110;
  static const double photoPreviewWidth = 120;
  static const double photoPreviewHeight = 160;
  static const double actionButton = 40;
  static const double formMaxWidth = 600;

  static const double authMaxWidth = 380;
  static const double buttonHeight = 52;
  static const double spinner = 20;

  static const double skeletonLine = 12;
  static const double skeletonLineShort = 64;
  static const double skeletonLineLong = 120;

  static const double borderWidth = 1;
  static const double borderWidthFocus = 1.2;
  static const double borderWidthSelected = 1.5;
  static const double elevation = 0;
  static const double shadowBlur = 16;
  static const double shadowOffsetY = 4;
  static const double disabledOpacity = 0.5;

  /// Distância (px) que um elemento sobe ao entrar na tela.
  static const double entranceOffset = 18;

  /// Escala de um card/botão enquanto está pressionado.
  static const double pressScale = 0.97;

  /// Escala da categoria selecionada.
  static const double selectedScale = 1.06;

  /// Zoom lento da foto do banner enquanto o slide está visível.
  static const double bannerZoom = 1.08;

  /// Deslocamento (fração da altura) do texto do banner ao entrar.
  static const double bannerTextOffset = 0.2;

  /// Opacidade mínima da pulsação do esqueleto de carregamento.
  static const double skeletonMinOpacity = 0.45;
}
