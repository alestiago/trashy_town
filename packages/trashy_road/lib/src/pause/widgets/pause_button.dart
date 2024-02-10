import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/src/pause/pause.dart';

/// A button that can be used to pause.
class PauseButton extends StatelessWidget {
  const PauseButton({
    required this.onPause,
    required this.onResume,
    super.key,
  });

  final bool Function() onPause;
  final bool Function() onResume;

  void _onPause(BuildContext context) {
    if (onPause()) {
      Navigator.of(context).push(PausePage.route(onResume: onResume));
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
