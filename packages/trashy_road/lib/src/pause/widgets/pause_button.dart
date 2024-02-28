import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/pause/pause.dart';

/// A button that can be used to pause.
class PauseButton extends StatelessWidget {
  const PauseButton({
    required this.onPause,
    required this.onResume,
    required this.onReplay,
    super.key,
  });

  /// A callback that is called when the button is pressed.
  ///
  /// If it returns `true`, the [PausePage] will be pushed.
  final bool Function() onPause;

  /// {@macro PausePage.onResume}
  final bool Function() onResume;

  /// {@macro PausePage.onReplay}
  final bool Function() onReplay;

  void _onPause(BuildContext context) {
    if (onPause()) {
      Navigator.of(context).push(
        PausePage.route(
          onResume: onResume,
          onReplay: onReplay,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedHoverSaturation(
      child: GestureDetector(
        onTap: () => _onPause(context),
        child: Assets.images.pauseButton.image(width: 50, height: 50),
      ),
    );
  }
}

class _AnimatedHoverSaturation extends StatefulWidget {
  const _AnimatedHoverSaturation({required this.child});

  final Widget child;

  @override
  State<_AnimatedHoverSaturation> createState() =>
      __AnimatedHoverSaturationState();
}

class __AnimatedHoverSaturationState extends State<_AnimatedHoverSaturation>
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
                  _saturationMatrix(value: _saturationAnimation.value),
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

List<double> _saturationMatrix({required double value}) {
  value = value * 100;

  if (value == 0) {
    return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  }

  final x = 1 + ((value > 0) ? ((3 * value) / 100) : (value / 100));
  const lumR = 0.3086;
  const lumG = 0.6094;
  const lumB = 0.082;

  return List<double>.from(
    <double>[
      (lumR * (1 - x)) + x,
      lumG * (1 - x),
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      (lumG * (1 - x)) + x,
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      lumG * (1 - x),
      (lumB * (1 - x)) + x,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ],
  ).toList();
}
