import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template GameStopwatch}
/// A stopwatch that shows the total time the game has been played for.
///
/// Requires a [GameBloc] to be provided within its widget tree.
/// {@endtemplate}
class GameStopwatch extends StatefulWidget {
  const GameStopwatch({super.key});

  @override
  State<GameStopwatch> createState() => _GameStopwatchState();
}

class _GameStopwatchState extends State<GameStopwatch>
    with SingleTickerProviderStateMixin {
  final _stopwatch = Stopwatch();

  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  void _stop() {
    _animation.stop();
    _stopwatch.stop();
  }

  void _start() {
    _animation.repeat();
    _stopwatch.start();
  }

  void _reset() {
    _animation.reset();
    _stopwatch.reset();
  }

  @override
  void dispose() {
    _animation.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            final hasStarted = previous.status == GameStatus.ready &&
                current.status == GameStatus.playing;
            final hasResumed = previous.status == GameStatus.paused &&
                current.status == GameStatus.playing;

            return hasStarted || hasResumed;
          },
          listener: (_, __) => _start(),
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            final hasCompleted = previous.status != GameStatus.completed &&
                current.status == GameStatus.completed;
            final hasPaused = previous.status == GameStatus.playing &&
                current.status == GameStatus.paused;

            return hasCompleted || hasPaused;
          },
          listener: (_, __) => _stop(),
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            final hasReset = previous.status == GameStatus.playing &&
                current.status == GameStatus.resetting;
            return hasReset;
          },
          listener: (_, __) => _reset(),
        ),
      ],
      child: DefaultTextStyle(
        style: style,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => Text(_stopwatch.elapsed.format()),
        ),
      ),
    );
  }
}

extension on Duration {
  String format() {
    final parts = <String>[];

    if (inHours > 0) {
      parts.add(inHours.toString().padLeft(2, '0'));
    }
    if (inMinutes > 0) {
      parts.add(inMinutes.remainder(60).toString().padLeft(2, '0'));
    }
    parts
      ..add(inSeconds.remainder(60).toString().padLeft(2, '0'))
      ..add(
        (inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0'),
      );

    return parts.take(2).join(':');
  }
}
