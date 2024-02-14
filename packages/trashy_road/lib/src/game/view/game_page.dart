import 'dart:math';

import 'package:flame/game.dart' hide Route;
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';
import 'package:trashy_road/src/pause/pause.dart';
import 'package:trashy_road/src/score/view/view.dart';

final _random = Random(0);

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

class _GameView extends StatefulWidget {
  const _GameView();

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  TrashyRoadGame? _game;

  @override
  Widget build(BuildContext context) {
    final loadingBloc = context.read<PreloadCubit>();
    final gameBloc = context.read<GameBloc>();

    TrashyRoadGame gameBuilder() {
      return kDebugMode
          ? DebugTrashyRoadGame(
              gameBloc: gameBloc,
              images: loadingBloc.images,
              random: _random,
            )
          : TrashyRoadGame(
              gameBloc: gameBloc,
              images: loadingBloc.images,
              random: _random,
            );
    }

    _game ??= gameBuilder();

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) => current.status == GameStatus.completed,
      listener: (context, state) {
        Navigator.pushReplacement(context, ScorePage.route());
      },
      child: BlocBuilder<GameBloc, GameState>(
        buildWhen: (previous, current) {
          return previous.status == GameStatus.playing &&
              current.status == GameStatus.resetting;
        },
        builder: (context, state) {
          if (state.status == GameStatus.resetting) {
            _game = gameBuilder();
            gameBloc.add(const GameReadyEvent());
          }

          return Stack(
            children: [
              GameWidget(game: _game!),
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
          );
        },
      ),
    );
  }
}
