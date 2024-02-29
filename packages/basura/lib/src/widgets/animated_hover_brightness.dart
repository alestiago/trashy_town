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
  final _focusNode = FocusNode();

  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final _saturationAnimation = Tween<double>(begin: 0, end: 0.25).animate(
    _animationController,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(_focusNode.requestFocus),
        onExit: (_) => setState(_focusNode.unfocus),
        child: GestureDetector(
          onTapDown: (_) => setState(_focusNode.requestFocus),
          onTapUp: (_) => setState(_focusNode.unfocus),
          onTapCancel: () => setState(_focusNode.unfocus),
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
