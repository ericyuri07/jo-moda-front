import 'package:flutter/material.dart';

import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_sizes.dart';

/// Área tocável que "afunda" de leve enquanto o dedo está em cima.
/// Se o gesto virar rolagem, volta ao normal sem disparar [onTap].
class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? AppSizes.pressScale : 1,
        duration: AppDurations.press,
        curve: AppCurves.standard,
        child: widget.child,
      ),
    );
  }
}
