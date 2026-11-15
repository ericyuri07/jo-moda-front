import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'network_image_box.dart';

/// Banner rotativo da Home, alimentado pelos produtos em destaque.
/// Gira sozinho a cada poucos segundos; o indicador ativo é um traço dourado.
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
    _timer = Timer.periodic(AppDurations.bannerAutoplay, (_) => _next());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (!_controller.hasClients || widget.products.length < 2) return;

    _controller.animateToPage(
      (_index + 1) % widget.products.length,
      duration: AppDurations.bannerSlide,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Column(
      children: <Widget>[
        Container(
          height: AppSizes.bannerHeight,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.card,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.products.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) => _BannerSlide(
                product: widget.products[i],
                onTap: () => widget.onTap(widget.products[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < widget.products.length; i++)
              AnimatedContainer(
                duration: AppDurations.dotChange,
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.hairline,
                ),
                width: i == _index
                    ? AppSizes.bannerDotActive
                    : AppSizes.bannerDot,
                height: AppSizes.bannerDot,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  color: i == _index ? AppColors.gold : AppColors.border,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          NetworkImageBox(url: product.imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[AppColors.transparent, AppColors.imageOverlay],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.bannerTag,
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.goldLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bannerName,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    AppStrings.bannerCta,
                    style: AppTextStyles.goldButton,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
