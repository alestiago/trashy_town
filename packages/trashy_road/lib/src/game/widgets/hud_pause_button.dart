import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/pause/pause.dart';

class HudPauseButton extends StatelessWidget {
  const HudPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();

    return PauseButton(
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
    );
  }
}
