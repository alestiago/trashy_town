import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(alestiago): Consider refactoring, if the [GameBloc] doesn't end up
    // being consumed by other widgets in the tree.

    return BlocProvider(
      create: (context) => GameBloc(),
      child: Builder(
        builder: (context) {
          final gameBloc = context.read<GameBloc>();

          return GameWidget.controlled(
            gameFactory: () => TrashyRoadGame(gameBloc: gameBloc),
          );
        },
      ),
    );
  }
}
