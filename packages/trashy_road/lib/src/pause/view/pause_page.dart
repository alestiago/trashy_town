import 'package:flutter/material.dart';
import 'package:trashy_road/src/maps/maps.dart';

/// {@template PausePage}
/// A page that displays the pause menu.
/// {@endtemplate}
class PausePage extends StatelessWidget {
  /// {@macro PausePage}
  const PausePage({
    required this.onResume,
    super.key,
  });

  static Route<void> route({
    required bool Function() onResume,
  }) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => PausePage(onResume: onResume),
    );
  }

  /// A callback that is called when the game is resumed.
  ///
  /// If it returns `true`, the game will be resumed. Otherwise, the game will
  /// remain paused.
  final bool Function() onResume;

  void _onResume(BuildContext context) {
    if (onResume()) {
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
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: IconButton(
          onPressed: () => _onResume(context),
          icon: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => _onMenu(context),
            child: const Text('Menu'),
          ),
        ],
      ),
    );
  }
}
