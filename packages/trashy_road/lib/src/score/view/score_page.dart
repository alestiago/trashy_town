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
    return MaterialPageRoute<void>(
      builder: (_) => ScorePage(identifier: identifier),
    );
  }

  void _onNextMap(BuildContext context, {required GameMap nextMap}) {
    if (nextMap.locked) return;

    final preloadCubit = context.read<PreloadCubit>();
    final tiledMap = preloadCubit.tiled.fromCache(nextMap.path);

    Navigator.of(context).pushReplacement(
      GamePage.route(
        identifier: nextMap.identifier,
        tiledMap: tiledMap,
      ),
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

    Navigator.of(context).pushReplacement(
      GamePage.route(
        identifier: map.identifier,
        tiledMap: tiledMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = BasuraTheme.of(context);
    final gameMapsBloc = context.read<GameMapsBloc>();

    final map = gameMapsBloc.state.maps[_identifier]!;
    final nextMap = gameMapsBloc.state.next(_identifier);
    final scoreRating = map.scoreRating;

    const textButtonSize = Size(200, 64);
    const spacing = SizedBox.square(dimension: 8);

    return DefaultTextStyle(
      style: theme.textTheme.button,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              // TODO(alestiago): Use background render when available.
              Assets.images.grass.path,
              repeat: ImageRepeat.repeat,
            ),
          ),
          SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: AnimatedStarRating(rating: scoreRating.value),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: spacing.height!,
                  runSpacing: spacing.height!,
                  children: [
                    SizedBox.fromSize(
                      size: textButtonSize,
                      child: BasuraGlossyTextButton(
                        onPressed: () => _onReplay(context),
                        label: 'Replay',
                      ),
                    ),
                    SizedBox.fromSize(
                      size: textButtonSize,
                      child: BasuraGlossyTextButton(
                        onPressed: () => _onMenu(context),
                        label: 'Menu',
                      ),
                    ),
                    SizedBox.fromSize(
                      size: textButtonSize,
                      child: nextMap != null
                          ? BasuraGlossyTextButton(
                              style: theme.glossyButtonTheme.primary,
                              onPressed: () =>
                                  _onNextMap(context, nextMap: nextMap),
                              label: 'Next',
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
