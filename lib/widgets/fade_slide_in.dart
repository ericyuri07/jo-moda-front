import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_sizes.dart';

/// Faz o [child] aparecer subindo levemente com fade, uma vez, ao entrar
/// na tela.
///
/// Em listas, passe o [index] do item para a entrada sair em sequência
/// (cascata). O atraso cresce com o índice até `AppDurations.maxStagger`,
/// para listas longas não ficarem esperando.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({required this.child, this.index = 0, super.key});

  final Widget child;
  final int index;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    final int delayMs = math.min(
      AppDurations.stagger.inMilliseconds * widget.index,
      AppDurations.maxStagger.inMilliseconds,
    );
    final int totalMs = delayMs + AppDurations.entrance.inMilliseconds;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(delayMs / totalMs, 1, curve: AppCurves.standard),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: AnimatedBuilder(
        animation: _progress,
        child: widget.child,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, (1 - _progress.value) * AppSizes.entranceOffset),
          child: child,
        ),
      ),
    );
  }
}
