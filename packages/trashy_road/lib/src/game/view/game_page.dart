import 'package:basura/basura.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/pause/pause.dart';
import 'package:trashy_road/src/score/view/view.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required String identifier,
    required TiledMap map,
    super.key,
  })  : _map = map,
        _identifier = identifier;

  /// The identifier for the route.
  static String identifier = 'game_page';

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

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) => current.status == GameStatus.completed,
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.images.grass.path,
              repeat: ImageRepeat.repeat,
              color: const Color.fromARGB(40, 0, 0, 0),
              colorBlendMode: BlendMode.darken,
            ),
          ),
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
              child: ColoredBox(
                color: Colors.red,
                child: GameStopwatch(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ColoredBox(
                color: Colors.red,
                child: PauseButton(
                  onPause: () {
                    gameBloc.add(const GamePausedEvent());
                    return true;
                  },
                  onResume: () {
                    gameBloc.add(const GameResumedEvent());
                    return true;
                  },
                  onReplay: () {
                    gameBloc.add(const GameResetEvent());
                    return true;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
