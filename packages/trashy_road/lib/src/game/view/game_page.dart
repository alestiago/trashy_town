import 'package:basura/basura.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/score/score.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required String identifier,
    required TiledMap map,
    super.key,
  })  : _map = map,
        _identifier = identifier;

  /// The identifier for the route.
  static String identifier = 'maps_menu';

  static Route<void> route({
    required String identifier,
    required TiledMap tiledMap,
  }) {
    return BasuraBlackEaseInOut<void>(
      settings: RouteSettings(name: identifier),
      builder: (_) => GamePage(
        identifier: identifier,
        map: tiledMap,
      ),
    );
  }

  /// The identifier of the game.
  final String _identifier;

  /// The map to play.
  ///
  /// Usually loaded from the [TiledCache] provided by the [PreloadCubit].
  final TiledMap _map;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GameBloc(
            identifier: _identifier,
            map: _map,
          ),
        ),
        BlocProvider(
          create: (context) => AudioCubit(
            audioCache: context.read<PreloadCubit>().audio,
          ),
        ),
      ],
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    final isTutorial =
        gameBloc.state.identifier == GameMapsState.tutorialIdentifier;

    return MultiBlocListener(
      listeners: [
        _GameCompletionListener(),
        _GameResetTimeIsUpListener(),
      ],
      child: Stack(
        children: [
          const Positioned.fill(child: _GameBackground()),
          const Align(child: TrashyRoadGameWidget()),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: InventoryHud(),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: TopHud(),
            ),
          ),
          if (isTutorial)
            const Align(
              alignment: Alignment(0, -0.6),
              child: GameTutorial(),
            ),
        ],
      ),
    );
  }
}

class _GameCompletionListener extends BlocListener<GameBloc, GameState> {
  _GameCompletionListener()
      : super(
          listenWhen: (previous, current) =>
              current.status == GameStatus.completed,
          listener: (context, state) {
            context.read<GameMapsBloc>().add(
                  GameMapCompletedEvent(
                    identifier: state.identifier,
                    score: state.score,
                  ),
                );
            Navigator.push(
              context,
              ScorePage.route(identifier: state.identifier),
            );
          },
        );
}

class _GameResetTimeIsUpListener extends BlocListener<GameBloc, GameState> {
  _GameResetTimeIsUpListener()
      : super(
          listenWhen: (previous, current) =>
              current.status == GameStatus.resetting &&
              current.resetReason == GameResetReason.timeIsUp,
          listener: (context, state) {
            final gameBloc = context.read<GameBloc>()
              ..add(const GamePausedEvent());
            final navigator = Navigator.of(context)
              ..push(GameTimeIsUpPage.route());
            Future<void>.delayed(const Duration(seconds: 3)).then((_) async {
              await Future<void>.delayed(const Duration(seconds: 3));
              gameBloc.add(const GameResumedEvent());
              await Future<void>.delayed(const Duration(milliseconds: 500));
              navigator.pop();
            });
          },
        );
}

class _GameBackground extends StatelessWidget {
  const _GameBackground();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.images.sprites.grass.path,
      repeat: ImageRepeat.repeat,
      color: const Color.fromARGB(40, 0, 0, 0),
      colorBlendMode: BlendMode.darken,
    );
  }
}
