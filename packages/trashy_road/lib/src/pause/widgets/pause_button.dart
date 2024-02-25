import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final style = BasuraTheme.of(context).glossyButtonTheme.secondary;

    return BasuraGlossyButton(
      style: style,
      onPressed: () => _onPause(context),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _PauseIcon(style: style),
      ),
    );
  }
}

class _PauseIcon extends StatelessWidget {
  const _PauseIcon({
    required this.style,
  });

  final BasuraGlossyButtonStyle style;

  @override
  Widget build(BuildContext context) {
    const size = Size(24, 24);

    final barSize = Size(8, size.height);
    final bar = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: style.outlineColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: [
          BoxShadow(
            color: style.outlineColor,
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
        color: BasuraColors.white,
      ),
      child: SizedBox.fromSize(size: barSize),
    );

    final middle = size.width / 2 - (barSize.width / 2);

    return Stack(
      children: [
        SizedBox.fromSize(size: size),
        Positioned(
          left: middle - (barSize.width / 1.1),
          child: bar,
        ),
        Positioned(
          left: middle + (barSize.width / 1.1),
          child: bar,
        ),
      ],
    );
  }
}
