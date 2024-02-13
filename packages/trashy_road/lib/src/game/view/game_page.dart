import 'dart:math';

import 'package:flame/game.dart' hide Route;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/debug_game.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/widgets/widgets.dart';
import 'package:trashy_road/src/loading/cubit/cubit.dart';
import 'package:trashy_road/src/pause/pause.dart';

final _random = Random(0);

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingBloc = context.read<PreloadCubit>();
    final map = loadingBloc.tiled.fromCache(Assets.tiles.map2);

    return BlocProvider(
      create: (context) => GameBloc(map: map),
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

    return BlocBuilder<GameBloc, GameState>(
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
    );
  }
}
