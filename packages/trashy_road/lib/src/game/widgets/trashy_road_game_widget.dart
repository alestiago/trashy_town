import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/audio/audio.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/loading/loading.dart';

final _random = Random(0);

class TrashyRoadGameWidget extends StatefulWidget {
  const TrashyRoadGameWidget({
    required this.onGameCreated,
    super.key,
  });

  /// Callback for when the game is created.
  final void Function(TrashyRoadGame game) onGameCreated;

  @override
  State<TrashyRoadGameWidget> createState() => _TrashyRoadGameWidgetState();
}

class _TrashyRoadGameWidgetState extends State<TrashyRoadGameWidget> {
  TrashyRoadGame? _game;

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    final audioBloc = context.read<AudioCubit>();
    final loadingBloc = context.read<PreloadCubit>();
    final resolution = Size(
      GameSettings.gridDimensions.x * 11,
      (GameSettings.gridDimensions.x * 11) * (1280 / 720),
    );

    TrashyRoadGame gameBuilder() {
      final game = kDebugMode
          ? DebugTrashyRoadGame(
              gameBloc: gameBloc,
              images: loadingBloc.images,
              audioBloc: audioBloc,
              resolution: resolution,
              random: _random,
            )
          : TrashyRoadGame(
              gameBloc: gameBloc,
              images: loadingBloc.images,
              audioBloc: audioBloc,
              resolution: resolution,
              random: _random,
            );
      widget.onGameCreated(game);
      return game;
    }

    _game ??= gameBuilder();

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) {
        return current.status == GameStatus.resetting;
      },
      listener: (context, state) {
        if (!mounted) return;
        setState(() => _game = gameBuilder());
        gameBloc.add(const GameReadyEvent());
      },
      child: SizedBox.fromSize(
        size: resolution,
        child: GameWidget(game: _game!),
      ),
    );
  }
}
