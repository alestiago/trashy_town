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

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();

    return Stack(
      children: [
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: InventoryHud(),
          ),
        ),
        GameWidget.controlled(
          gameFactory: () => TrashyRoadGame(gameBloc: gameBloc),
        ),
      ],
    );
  }
}
