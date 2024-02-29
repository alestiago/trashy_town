import 'package:basura/basura.dart';
import 'package:flutter/material.dart';
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

    return Center(
      child: SizedBox.square(
        dimension: (screenSize.shortestSide * 0.5).clamp(250, double.infinity),
        child: _PaperBackground(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: AnimatedStarRating(rating: scoreRating.value),
              ),
              HoverableTextButton(text: 'Replay', onPressed: _onReplay),
              HoverableTextButton(text: 'Menu', onPressed: _onMenu),
              if (nextMap != null)
                HoverableTextButton(
                  text: 'Next',
                  onPressed: (context) => _onNextMap(context, nextMap: nextMap),
                ),
            ],
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
