import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/maps/maps.dart';
import 'package:trashy_road/src/pause/pause.dart';

/// A button that can be used to pause.
class PauseButton extends StatelessWidget {
  const PauseButton({
    super.key,
  });

  void _onPause(BuildContext context) {
    final gameBloc = context.read<GameBloc>()..add(const GamePausedEvent());
    final gameMapsBloc = context.read<GameMapsBloc>();
    final gameMap = gameMapsBloc.state.maps[gameBloc.state.identifier]!;

    Navigator.of(context).push(
      PausePage.route(
        title: gameMap.displayName,
        onResume: () {
          gameBloc.add(const GameResumedEvent());
          return true;
        },
        onReplay: () {
          gameBloc.add(const GameResetEvent());
          return true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverBrightness(
      child: GestureDetector(
        onTap: () => _onPause(context),
        child: Assets.images.pauseIcon.image(width: 50, height: 50),
      ),
    );
  }
}
