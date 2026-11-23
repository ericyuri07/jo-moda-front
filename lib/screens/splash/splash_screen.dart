import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_curves.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../services/service_locator.dart';
import '../../widgets/jo_logo.dart';

/// Abertura do app (antes do login), feita numa única animação:
///
/// 1. a logo aparece crescendo de leve;
/// 2. um brilho atravessa a logo;
/// 3. uma linha fina se abre embaixo dela;
/// 4. tudo some em fade e o app segue para o login (ou para a loja, se a
///    sessão já estiver aberta).
///
/// Tocar na tela pula a abertura.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.splash,
  );

  late final Animation<double> _logoOpacity = _interval(0, 0.3);
  late final Animation<double> _logoScale = Tween<double>(
    begin: AppSizes.splashStartScale,
    end: 1,
  ).animate(_interval(0, 0.45));
  late final Animation<double> _shine = _interval(
    0.3,
    0.7,
    curve: AppCurves.emphasized,
  );
  late final Animation<double> _line = _interval(0.45, 0.75);
  late final Animation<double> _exit = _interval(0.86, 1);

  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _finish();
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _interval(
    double begin,
    double end, {
    Curve curve = AppCurves.standard,
  }) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: curve),
    );
  }

  void _finish() {
    if (_finished || !mounted) return;
    _finished = true;

    if (authService.isAdmin) {
      context.goNamed(AppRoutes.adminProducts);
    } else {
      context.goNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _finish,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Opacity(
              opacity: 1 - _exit.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: _buildShiningLogo(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: AppSizes.splashLineWidth * _line.value,
                    height: AppSizes.bannerIndicatorHeight,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Logo com uma faixa de brilho diagonal que a atravessa da esquerda para
  /// a direita (só onde a logo tem cor, graças ao `srcATop`).
  Widget _buildShiningLogo() {
    const double band = AppSizes.splashShineWidth;
    final double center = -band + (1 + 2 * band) * _shine.value;

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const <Color>[
          AppColors.transparent,
          AppColors.shine,
          AppColors.transparent,
        ],
        stops: <double>[
          (center - band).clamp(0, 1),
          center.clamp(0, 1),
          (center + band).clamp(0, 1),
        ],
      ).createShader(bounds),
      child: const JoLogo(size: AppSizes.logoSplash),
    );
  }
}
