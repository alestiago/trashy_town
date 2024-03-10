import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template GameBackgroundMusicListener}
/// Listens to the [GameBloc] and controls the background music accordingly.
/// {@endtemplate}
class GameBackgroundMusicListener extends StatelessWidget {
  const GameBackgroundMusicListener({
    required this.child,
    super.key,
  });

  final Widget child;

  void _playBackgroundMusic(BuildContext context) {
    final audioBloc = context.read<AudioCubit>();
    if (audioBloc.backgroundMusic.isPlaying) return;
    audioBloc.backgroundMusic.play(
      Assets.audio.backgroundMusic,
      volume: 0.2,
    );
  }

  void _pauseBackgroundMusic(BuildContext context) {
    final audioBloc = context.read<AudioCubit>();
    audioBloc.backgroundMusic.pause();
  }

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    if (_shouldPlayBackgroundMusic(gameBloc.state, gameBloc.state)) {
      _playBackgroundMusic(context);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: _shouldPlayBackgroundMusic,
          listener: (context, state) {
            _playBackgroundMusic(context);
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: _shouldPauseBackgroundMusic,
          listener: (context, state) {
            _pauseBackgroundMusic(context);
          },
        ),
      ],
      child: child,
    );
  }
}

bool _shouldPlayBackgroundMusic(GameState previous, GameState current) {
  return current.status == GameStatus.playing ||
      current.status == GameStatus.ready;
}

bool _shouldPauseBackgroundMusic(GameState previous, GameState current) {
  return current.status == GameStatus.paused;
}
