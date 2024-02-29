import 'package:flutter/widgets.dart';

/// {@template AnimatedHoverBrightness}
/// A widget that animates the brightness of its child when hovered or pressed.
/// {@endtemplate}
class AnimatedHoverBrightness extends StatefulWidget {
  /// {@macro AnimatedHoverBrightness}
  const AnimatedHoverBrightness({
    required this.child,
    super.key,
  });

  /// The child to animate.
  final Widget child;

  @override
  State<AnimatedHoverBrightness> createState() =>
      _AnimatedHoverBrightnessState();
}

class _AnimatedHoverBrightnessState extends State<AnimatedHoverBrightness>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;

  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final _saturationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
    _animationController,
  );

  void _focus() {
    setState(() => _isFocused = true);
    _animationController.forward();
  }

  void _unfocus() {
    setState(() => _isFocused = false);
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _focus(),
      onExit: (_) => _unfocus(),
      child: GestureDetector(
        onTapDown: (_) => _focus(),
        onTapUp: (_) => _unfocus(),
        onTapCancel: _unfocus,
        behavior: HitTestBehavior.translucent,
        child: AnimatedBuilder(
          animation: _saturationAnimation,
          child: widget.child,
          builder: (context, child) {
            return ColorFiltered(
              colorFilter: ColorFilter.matrix(
                _brightnessAdjustMatrix(
                  brightness: _saturationAnimation.value,
                ),
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}

List<double> _brightnessAdjustMatrix({required double brightness}) {
  late final double value;
  if (brightness <= 0) {
    value = brightness * 255;
  } else {
    value = brightness * 100;
  }

  if (value == 0) {
    return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  }

  return List<double>.from(<double>[
    1,
    0,
    0,
    0,
    value,
    0,
    1,
    0,
    0,
    value,
    0,
    0,
    1,
    0,
    value,
    0,
    0,
    0,
    1,
    0,
  ]).toList();
}
