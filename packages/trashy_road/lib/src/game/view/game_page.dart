import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/pause/pause.dart';
import 'package:trashy_road/src/score/view/view.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    required TiledMap map,
    super.key,
  }) : _map = map;

  static Route<void> route({
    required TiledMap tiledMap,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => GamePage(map: tiledMap),
    );
  }

  /// The map to play.
  ///
  /// Usually loaded from the [TiledCache] provided by the [PreloadCubit].
  final TiledMap _map;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(map: _map),
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
        Navigator.pushReplacement(context, ScorePage.route());
      },
      child: Stack(
        children: [
          const TrashyRoadGameWidget(),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GameStopwatch(),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: InventoryHud(),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PauseButton(
                onPause: () {
                  gameBloc.add(const GamePausedEvent());
                  return true;
                },
                onResume: () {
                  gameBloc.add(const GameResumedEvent());
                  return true;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
