import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/widgets/widgets.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
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
    final gameBloc = context.read<GameBloc>();
    _game ??= TrashyRoadGame(gameBloc: gameBloc);

    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) {
        return previous.status == GameStatus.playing &&
            current.status == GameStatus.resetting;
      },
      builder: (context, state) {
        if (state.status == GameStatus.resetting) {
          _game = TrashyRoadGame(gameBloc: gameBloc);
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
          ],
        );
      },
    );
  }
}
