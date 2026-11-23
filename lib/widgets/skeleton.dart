import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';

/// Bloco cinza pulsante que ocupa o lugar do conteúdo enquanto ele carrega.
/// Sem [width]/[height], ocupa todo o espaço disponível.
class Skeleton extends StatefulWidget {
  const Skeleton({
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.skeletonPulse,
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 1,
    end: AppSizes.skeletonMinOpacity,
  ).animate(CurvedAnimation(parent: _controller, curve: AppCurves.pulse));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.skeleton,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
