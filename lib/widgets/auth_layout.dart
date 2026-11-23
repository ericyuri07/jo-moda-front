import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'fade_slide_in.dart';
import 'jo_logo.dart';

/// Moldura comum das telas de entrada (login e cadastro de cliente e de
/// ADM): fundo claro, logo, título em serifa e o formulário logo abaixo,
/// sem card. Logo, título e formulário entram em sequência.
/// [badge] mostra um selo acima do título (ex.: "ÁREA ADMINISTRATIVA").
/// [onBack] mostra a seta de voltar e responde ao botão voltar do aparelho.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.children,
    this.subtitle,
    this.badge,
    this.onBack,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback? onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final String? info = subtitle;
    final String? tag = badge;
    final VoidCallback? back = onBack;

    final Widget page = Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.authMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (back != null)
                    IconButton(
                      tooltip: AppStrings.backToShop,
                      color: AppColors.textPrimary,
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: back,
                    ),
                  const FadeSlideIn(
                    child: Center(child: JoLogo(size: AppSizes.logoAuth)),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FadeSlideIn(
                    index: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (tag != null) ...<Widget>[
                          _Badge(tag),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        Text(title, style: AppTextStyles.authTitle),
                        if (info != null) ...<Widget>[
                          const SizedBox(height: AppSpacing.sm),
                          Text(info, style: AppTextStyles.authSubtitle),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FadeSlideIn(
                    index: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (back == null) return page;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: page,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Text(text, style: AppTextStyles.overline),
    );
  }
}
