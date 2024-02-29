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
    return _PausePageRouteBuilder(
      builder: (context) => PausePage(onResume: onResume, onReplay: onReplay),
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

    return Center(
      child: SizedBox.square(
        dimension: (screenSize.shortestSide * 0.4).clamp(250, double.infinity),
        child: _PaperBackground(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoverableTextButton(text: 'Resume', onPressed: _onResume),
                spacing,
                HoverableTextButton(text: 'Replay', onPressed: _onReplay),
                spacing,
                HoverableTextButton(text: 'Menu', onPressed: _onMenu),
              ],
            ),
          ),
        ),
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

class _PausePageRouteBuilder<T> extends PageRouteBuilder<T> {
  _PausePageRouteBuilder({
    required WidgetBuilder builder,
    super.settings,
  }) : super(
          opaque: false,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0),
            );
            final end = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0.6),
            );

            final decorationCurvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.easeIn);
            final decorationTween = DecorationTween(begin: begin, end: end);
            final decorationAnimate =
                decorationTween.animate(decorationCurvedAnimation);

            final scaleCurvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.easeIn);
            final scaleTween = Tween<double>(begin: 0.5, end: 1);
            final scaleAnimate = scaleTween.animate(scaleCurvedAnimation);

            final opacityCurve =
                CurvedAnimation(parent: animation, curve: Curves.linear);
            final opacityTween = Tween<double>(begin: 0.2, end: 1);
            final opacityAnimate = opacityTween.animate(opacityCurve);

            return DecoratedBoxTransition(
              decoration: decorationAnimate,
              child: ScaleTransition(
                scale: scaleAnimate,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: opacityAnimate.value,
                  child: child,
                ),
              ),
            );
          },
        );
}
