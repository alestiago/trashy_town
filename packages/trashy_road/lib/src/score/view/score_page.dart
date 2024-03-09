import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/score/score.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    required String identifier,
    super.key,
  }) : _identifier = identifier;

  final String _identifier;

  static Route<void> route({
    required String identifier,
  }) {
    return _ScorePageRouteBuilder<void>(
      builder: (_) => ScorePage(identifier: identifier),
    );
  }

  void _onNextMap(BuildContext context, {required GameMap nextMap}) {
    if (nextMap.locked) return;

    final preloadCubit = context.read<PreloadCubit>();
    final tiledMap = preloadCubit.tiled.fromCache(nextMap.path);

    Navigator.of(context).pushAndRemoveUntil(
      GamePage.route(
        identifier: nextMap.identifier,
        tiledMap: tiledMap,
      ),
      (route) => route.settings.name == GamePage.identifier,
    );
  }

  void _onMenu(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == MapsMenuPage.identifier,
    );
  }

  void _onReplay(BuildContext context) {
    final gameMapsBloc = context.read<GameMapsBloc>();
    final preloadCubit = context.read<PreloadCubit>();

    final map = gameMapsBloc.state.maps[_identifier]!;
    final tiledMap = preloadCubit.tiled.fromCache(map.path);

    Navigator.of(context).pushAndRemoveUntil(
      GamePage.route(
        identifier: map.identifier,
        tiledMap: tiledMap,
      ),
      (route) => route.settings.name == GamePage.identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final gameMapsBloc = context.read<GameMapsBloc>();

    final map = gameMapsBloc.state.maps[_identifier]!;
    final nextMap = gameMapsBloc.state.next(_identifier);
    final scoreRating = map.scoreRating;

    final basuraTheme = BasuraTheme.of(context);
    final textStyle = basuraTheme.textTheme.cardHeading.copyWith(
      letterSpacing: 0,
      fontSize: 50,
    );

    final dimension =
        (screenSize.shortestSide * 0.5).clamp(300, 500).toDouble();

    return DefaultTextStyle(
      style: textStyle,
      child: Center(
        child: SizedBox.square(
          dimension: dimension,
          child: _PaperBackground(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: AutoSizeText('Nice!', style: textStyle),
                        ),
                        SizedBox(
                          height: 80,
                          child: AnimatedStarRating(rating: scoreRating.value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ImageIcon(
                          imagePath: Assets.images.display.replayIcon.path,
                          onPressed: () => _onReplay(context),
                        ),
                        if (nextMap != null)
                          _ImageIcon(
                            imagePath: Assets.images.display.nextIcon.path,
                            dimension: 80,
                            onPressed: () =>
                                _onNextMap(context, nextMap: nextMap),
                          ),
                        _ImageIcon(
                          imagePath: Assets.images.display.menuIcon.path,
                          onPressed: () => _onMenu(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaperBackground extends StatelessWidget {
  const _PaperBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final preloadCubit = context.read<PreloadCubit>();
    final image = preloadCubit.imageProviderCache
        .fromCache(Assets.images.display.paperBackground.path);

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}

class _ImageIcon extends StatelessWidget {
  const _ImageIcon({
    required this.imagePath,
    this.onPressed,
    this.dimension = 50,
  });

  final String imagePath;

  final VoidCallback? onPressed;

  final double dimension;

  @override
  Widget build(BuildContext context) {
    final preloadCubit = context.read<PreloadCubit>();
    final image = preloadCubit.imageProviderCache.fromCache(imagePath);

    return AnimatedHoverBrightness(
      child: GestureDetector(
        onTap: onPressed,
        child: Image(
          image: image,
          width: dimension,
          height: dimension,
          filterQuality: FilterQuality.medium,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ScorePageRouteBuilder<T> extends PageRouteBuilder<T> {
  _ScorePageRouteBuilder({
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
              color: const Color(0xff000000).withOpacity(0.3),
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
