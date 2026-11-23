import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'network_image_box.dart';
import 'pressable_scale.dart';

/// Banner rotativo da Home, alimentado pelos produtos em destaque.
///
/// Gira sozinho a cada poucos segundos (o tempo recomeça se o usuário
/// arrastar). A foto do slide visível dá um zoom lento e o texto entra
/// subindo; o indicador é uma linha fina que se alonga no slide atual.
class HomeBanner extends StatefulWidget {
  const HomeBanner({required this.products, required this.onTap, super.key});

  final List<Product> products;
  final void Function(Product product) onTap;

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(AppDurations.bannerAutoplay, (_) => _next());
  }

  void _next() {
    if (!_controller.hasClients || widget.products.length < 2) return;

    _controller.animateToPage(
      (_index + 1) % widget.products.length,
      duration: AppDurations.bannerSlide,
      curve: AppCurves.emphasized,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _index = index);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SizedBox(
              height: AppSizes.bannerHeight,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.products.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, i) => _BannerSlide(
                  product: widget.products[i],
                  active: i == _index,
                  onTap: () => widget.onTap(widget.products[i]),
                ),
              ),
            ),
          ),
        ),
        if (widget.products.length > 1) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < widget.products.length; i++)
                AnimatedContainer(
                  duration: AppDurations.dotChange,
                  curve: AppCurves.standard,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.hairline,
                  ),
                  width: i == _index
                      ? AppSizes.bannerIndicatorActive
                      : AppSizes.bannerIndicator,
                  height: AppSizes.bannerIndicatorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    color: i == _index ? AppColors.primary : AppColors.border,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    required this.product,
    required this.active,
    required this.onTap,
  });

  final Product product;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedScale(
            scale: active ? AppSizes.bannerZoom : 1,
            duration: AppDurations.bannerAutoplay,
            curve: AppCurves.standard,
            child: NetworkImageBox(url: product.imageUrl),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: <Color>[AppColors.transparent, AppColors.imageOverlay],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: AnimatedSlide(
              offset: active
                  ? Offset.zero
                  : const Offset(0, AppSizes.bannerTextOffset),
              duration: AppDurations.entrance,
              curve: AppCurves.standard,
              child: AnimatedOpacity(
                opacity: active ? 1 : 0,
                duration: AppDurations.entrance,
                curve: AppCurves.standard,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      AppStrings.bannerTag,
                      style: AppTextStyles.bannerTag,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bannerName,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Row(
                      children: <Widget>[
                        Text(
                          AppStrings.bannerCta,
                          style: AppTextStyles.bannerCta,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppSizes.iconXs,
                          color: AppColors.textOnDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
