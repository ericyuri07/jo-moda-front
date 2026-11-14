/// Dimensões fixas de componentes e durações de animação.
abstract final class AppSizes {
  // Ícones
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 30;
  static const double iconXl = 32;

  // Logo e cabeçalho
  static const double logoAuth = 170;
  static const double logoDrawer = 96;

  // Títulos de seção (traço dourado)
  static const double sectionBarWidth = 28;
  static const double sectionBarHeight = 3;

  // Home
  static const double bannerHeight = 210;
  static const double bannerDot = 7;
  static const double bannerDotActive = 22;
  static const double categoryAvatar = 66;
  static const double categoryWidth = 76;
  static const double categoryListHeight = 112;
  static const double productCardAspectRatio = 0.58;

  // Detalhes do produto
  static const double galleryHeight = 400;
  static const double thumbSize = 60;
  static const double optionChipHeight = 38;
  static const double optionChipMinWidth = 48;
  static const double relatedCardWidth = 160;
  static const double relatedListHeight = 290;
  static const double stepperHeight = 52;
  static const double stepperWidth = 124;
  static const double stepperHeightCompact = 34;
  static const double stepperWidthCompact = 100;
  static const double primaryButtonHeight = 52;
  static const int lowStockLimit = 5;

  // Carrinho
  static const double cartImageWidth = 88;
  static const double cartImageHeight = 110;
  static const double toggleHeight = 48;

  // Administração
  static const double adminThumb = 64;
  static const double stockFieldWidth = 110;
  static const double photoPreviewWidth = 120;
  static const double photoPreviewHeight = 160;
  static const double actionButton = 40;

  /// Foto reduzida antes do upload (o back-end aceita até 2 MB).
  static const double uploadMaxDimension = 1600;
  static const int uploadQuality = 85;
  static const double formMaxWidth = 600;

  // Estados (vazio / erro)
  static const double stateIconCircle = 76;

  // Entrada
  static const double authMaxWidth = 360;
  static const double goldButtonHeight = 48;
  static const double buttonHeight = 50;
  static const double spinner = 20;

  // Bordas, sombras e opacidade
  static const double borderWidth = 1;
  static const double borderWidthFocus = 1.5;
  static const double borderWidthSelected = 2;
  static const double elevation = 2;
  static const double shadowBlur = 18;
  static const double shadowOffsetY = 6;
  static const double disabledOpacity = 0.6;
}

abstract final class AppDurations {
  static const Duration bannerAutoplay = Duration(seconds: 4);
  static const Duration bannerSlide = Duration(milliseconds: 450);
  static const Duration dotChange = Duration(milliseconds: 250);
  static const Duration selection = Duration(milliseconds: 180);
  static const Duration requestTimeout = Duration(seconds: 15);
}
