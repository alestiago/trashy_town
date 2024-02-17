import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return IconButton(
      onPressed: () => _onPause(context),
      icon: const Icon(CupertinoIcons.pause),
    );
  }
}
