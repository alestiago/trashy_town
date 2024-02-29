import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/gen/assets.gen.dart';
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
    const spacing = SizedBox(height: 8);
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: BasuraColors.black.withOpacity(0.3),
      body: Center(
        child: SizedBox.square(
          dimension:
              (screenSize.shortestSide * 0.4).clamp(250, double.infinity),
          child: _PaperBackground(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ResumeButton(onPressed: _onResume),
                  spacing,
                  _ReplayButton(onPressed: _onReplay),
                  spacing,
                  _MenuButton(onPressed: _onMenu),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  const _ResumeButton({required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    return GestureDetector(
      onTap: () => onPressed(context),
      child: AnimatedHoverBrightness(
        child: AutoSizeText(
          'Resume',
          style: theme.textTheme.cardSubheading,
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    return GestureDetector(
      onTap: () => onPressed(context),
      child: AutoSizeText(
        'Menu',
        style: theme.textTheme.cardSubheading,
      ),
    );
  }
}

class _ReplayButton extends StatelessWidget {
  const _ReplayButton({required this.onPressed});

  final void Function(BuildContext context) onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    return GestureDetector(
      onTap: () => onPressed(context),
      child: AutoSizeText(
        'Replay',
        style: theme.textTheme.cardSubheading,
      ),
    );
  }
}

class _PaperBackground extends StatefulWidget {
  const _PaperBackground({required this.child});

  final Widget child;

  @override
  State<_PaperBackground> createState() => __PaperBackgroundState();
}

class __PaperBackgroundState extends State<_PaperBackground> {
  final _image = Assets.images.paperBackground.provider();

  late final Future<void> _cacheImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cacheImage = precacheImage(_image, context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cacheImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _image,
              fit: BoxFit.fill,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
