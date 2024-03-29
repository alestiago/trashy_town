import 'package:basura/basura.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/audio/audio.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/maps/maps.dart';

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

  bool _countingDown = false;
  bool _timeIsUp = false;

  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..addListener(_onTick);

  void _stop() {
    _animation.stop();
    _stopwatch.stop();

    if (mounted && !_timeIsUp) {
      context.read<AudioCubit>().pauseEffect(GameSoundEffects.runningTime);
    }
  }

  void _start() {
    _animation.repeat(reverse: true);
    _stopwatch.start();

    if (mounted && _countingDown) {
      context.read<AudioCubit>().resumeEffect(GameSoundEffects.runningTime);
    }
  }

  void _reset() {
    _animation.reset();
    _stopwatch.reset();
    _countingDown = false;

    if (mounted) {
      context.read<AudioCubit>().stopEffect(GameSoundEffects.runningTime);
    }
  }

  void _onTick() {
    if (!mounted) return;

    final gameBloc = context.read<GameBloc>();
    final mapsBloc = context.read<GameMapsBloc>();
    final map = mapsBloc.state.maps[gameBloc.state.identifier]!;

    final completionSeconds = map.completionSeconds;

    final timeLeft = (completionSeconds * Duration.millisecondsPerSecond) -
        _stopwatch.elapsed.inMilliseconds;
    if (timeLeft < 10100 && !_countingDown) {
      _countingDown = true;
      context.read<AudioCubit>().playEffect(GameSoundEffects.runningTime);
    }

    _timeIsUp = _stopwatch.elapsed.inSeconds >= completionSeconds;
    if (_timeIsUp && gameBloc.state.status == GameStatus.playing) {
      gameBloc.add(const GameLostEvent(reason: GameLostReason.timeIsUp));
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BasuraTheme.of(context).textTheme.cardSubheading;

    return MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            return current.status == GameStatus.playing;
          },
          listener: (_, __) => _start(),
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            final hasCompleted = previous.status != GameStatus.completed &&
                current.status == GameStatus.completed;
            final hasPaused = previous.status == GameStatus.playing &&
                current.status == GameStatus.paused;
            final hasLost = current.status == GameStatus.lost;

            return hasCompleted || hasPaused || hasLost;
          },
          listener: (_, __) => _stop(),
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) {
            return previous.status == GameStatus.resetting;
          },
          listener: (_, __) => _reset(),
        ),
      ],
      child: DefaultTextStyle(
        style: style,
        child: _ProgressBar(
          animation: _animation,
          stopwatch: _stopwatch,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required AnimationController animation,
    required Stopwatch stopwatch,
  })  : _animation = animation,
        _stopwatch = stopwatch;

  final AnimationController _animation;
  final Stopwatch _stopwatch;

  @override
  Widget build(BuildContext context) {
    final gameBloc = BlocProvider.of<GameBloc>(context);
    final gameMapsBloc = BlocProvider.of<GameMapsBloc>(context);
    final gameMap = gameMapsBloc.state.maps[gameBloc.state.identifier]!;

    final completionsSeconds = gameMap.completionSeconds;
    final stopwatchRotationTween = Tween<double>(begin: -0.2, end: 0.2);

    return LayoutBuilder(
      builder: (context, constraints) {
        // TODO(alestiago): Refactor this logic and rely on the Flutter
        // framework to calculate these by sending constraints down the tree,
        // if possible.
        final prefferredBarWidth =
            (((constraints.maxWidth - 40) / Inventory.size).clamp(10.0, 40.0)) *
                Inventory.size;
        final availableSpace = MediaQuery.of(context).size.width - 250;
        final canFit = availableSpace > prefferredBarWidth;
        final barWidth = canFit ? prefferredBarWidth : availableSpace;
        final barSize = Size(barWidth > 0 ? barWidth : 0, 18);
        final starSize = Size.square(barSize.height + 20);

        Alignment alignStar(int seconds) {
          final horizontalAlign = (1 - (seconds / completionsSeconds))
              .normalize(max: 1, min: 0, newMax: 1, newMin: -1);
          final horizontalShift = (starSize.width / 2) / barSize.width;

          return Alignment(horizontalAlign + horizontalShift, 0);
        }

        return AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            final seconds = _stopwatch.elapsed.inSeconds;
            final percentageLeft = 1 - (seconds / completionsSeconds);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.fromSize(
                  size: starSize,
                  child: Transform.rotate(
                    angle: stopwatchRotationTween.evaluate(_animation),
                    child: const Hero(
                      tag: GameTimeIsUpPage.heroTag,
                      child: StopwatchIcon(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox.fromSize(
                  size: Size(barSize.width, starSize.height),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.translate(
                          // Eye-balled offset to align the bar with the stars.
                          offset: const Offset(0, 1),
                          child: SizedBox(
                            width: barSize.width,
                            child: AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 500),
                              alignment: Alignment.centerLeft,
                              widthFactor: percentageLeft.clamp(0, 1),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 4,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: alignStar(gameMap.ratingSteps.$3),
                        child: SizedBox.fromSize(
                          size: starSize,
                          child: AnimatedStar(
                            faded: gameMap.ratingSteps.$3 < seconds,
                          ),
                        ),
                      ),
                      Align(
                        alignment: alignStar(gameMap.ratingSteps.$2),
                        child: SizedBox.fromSize(
                          size: starSize,
                          child: AnimatedStar(
                            faded: gameMap.ratingSteps.$2 < seconds,
                          ),
                        ),
                      ),
                      Align(
                        alignment: alignStar(gameMap.ratingSteps.$1),
                        child: SizedBox.fromSize(
                          size: starSize,
                          child: AnimatedStar(
                            faded: gameMap.ratingSteps.$1 < seconds,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

extension on double {
  double normalize({
    required double min,
    required double max,
    required double newMin,
    required double newMax,
  }) {
    return ((this - min) / (max - min)) * (newMax - newMin) + newMin;
  }
}
