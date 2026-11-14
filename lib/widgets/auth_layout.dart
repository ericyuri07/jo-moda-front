import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'jo_logo.dart';

/// Moldura comum das telas de entrada (login e cadastro de cliente e de
/// ADM): fundo escuro com brilho dourado, logo e card com borda dourada.
/// [badge] mostra um selo acima do título (ex.: "ÁREA ADMINISTRATIVA").
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.children,
    this.subtitle,
    this.badge,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? badge;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final String? info = subtitle;
    final String? tag = badge;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundDeep,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          // Brilho dourado suave atrás da logo, escurecendo até as bordas.
          gradient: RadialGradient(
            center: Alignment(0, -0.55),
            radius: 0.9,
            colors: <Color>[
              AppColors.goldGlow,
              AppColors.authBackground,
              AppColors.authBackgroundDeep,
            ],
            stops: <double>[0, 0.55, 1],
          ),
        ),
        child: SafeArea(
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
                  children: <Widget>[
                    const JoLogo(size: AppSizes.logoAuth),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.authCard,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: AppColors.goldBorder,
                          width: AppSizes.borderWidth,
                        ),
                        boxShadow: AppShadows.raised,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (tag != null) ...<Widget>[
                            _Badge(tag),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          Text(title, style: AppTextStyles.authTitle),
                          if (info != null) ...<Widget>[
                            const SizedBox(height: AppSpacing.xs),
                            Text(info, style: AppTextStyles.authSubtitle),
                          ],
                          const SizedBox(height: AppSpacing.xl),
                          ...children,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.gold, width: AppSizes.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.admin_panel_settings_outlined,
            size: AppSizes.iconXs,
            color: AppColors.gold,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.overline.copyWith(color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}
