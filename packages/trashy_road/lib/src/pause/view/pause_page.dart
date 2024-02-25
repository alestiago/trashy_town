import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/src/maps/maps.dart';

/// {@template PausePage}
/// A page that displays the pause menu.
/// {@endtemplate}
class PausePage extends StatelessWidget {
  /// {@macro PausePage}
  const PausePage({
    required this.onResume,
    required this.onReplay,
    super.key,
  });

  static Route<void> route({
    required bool Function() onResume,
    required bool Function() onReplay,
  }) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => PausePage(
        onResume: onResume,
        onReplay: onReplay,
      ),
    );
  }

  /// {@template PausePage.onResume}
  /// A callback that is called when the game is resumed.
  ///
  /// If it returns `true`, the [PausePage] will be popped.
  /// {@endtemplate}
  final bool Function() onResume;

  /// {@template PausePage.onReplay}
  /// A callback that is called when the game is replayed.
  ///
  /// If it returns `true`, the [PausePage] will be popped.
  /// {@endtemplate}
  final bool Function() onReplay;

  void _onResume(BuildContext context) {
    if (onResume()) {
      Navigator.of(context).pop();
    }
  }

  void _onReplay(BuildContext context) {
    if (onReplay()) {
      Navigator.of(context).pop();
    }
  }

  void _onMenu(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == MapsMenuPage.identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    const textButtonSize = Size(200, 64);
    const spacing = SizedBox(height: 8);

    return Scaffold(
      backgroundColor: BasuraColors.black.withOpacity(0.3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: textButtonSize,
              child: BasuraGlossyTextButton(
                label: 'Resume',
                style: theme.glossyButtonTheme.primary,
                onPressed: () => _onResume(context),
              ),
            ),
            spacing,
            SizedBox.fromSize(
              size: textButtonSize,
              child: BasuraGlossyTextButton(
                label: 'Replay',
                onPressed: () => _onReplay(context),
              ),
            ),
            spacing,
            SizedBox.fromSize(
              size: textButtonSize,
              child: BasuraGlossyTextButton(
                label: 'Menu',
                onPressed: () => _onMenu(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
