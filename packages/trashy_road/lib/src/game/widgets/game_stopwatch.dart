import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/gen/assets.gen.dart';
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
    final style = BasuraTheme.of(context).textTheme.cardSubheading;

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
            return current.status == GameStatus.resetting;
          },
          listener: (_, __) => _reset(),
        ),
      ],
      child: DefaultTextStyle(
        style: style,
        child: _PaperBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: _ProgressBar(
              animation: _animation,
              stopwatch: _stopwatch,
            ),
          ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            final seconds = _stopwatch.elapsed.inSeconds;
            final percentageLeft = 1 - (seconds / completionsSeconds);

            final barSize = Size(
              (((constraints.maxWidth - 40) / Inventory.size)
                      .clamp(10.0, 40.0)) *
                  Inventory.size,
              18,
            );
            final starSize = Size.square(barSize.height + 8);

            final star = Assets.images.starFilledGolden
                .svg(height: starSize.height, width: starSize.width);

            return SizedBox.fromSize(
              size: Size(barSize.width, starSize.height),
              child: Stack(
                children: [
                  Align(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: BasuraColors.gray,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: BasuraColors.starYellow.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SizedBox(
                              width: barSize.width * percentageLeft,
                              height: barSize.height,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(
                      (1 - (gameMap.ratingSteps.$1 / completionsSeconds))
                          .normalize(max: 1, min: 0, newMax: 1, newMin: -1),
                      0,
                    ),
                    child: star,
                  ),
                  Align(
                    alignment: Alignment(
                      (1 - (gameMap.ratingSteps.$2 / completionsSeconds))
                          .normalize(max: 1, min: 0, newMax: 1, newMin: -1),
                      0,
                    ),
                    child: star,
                  ),
                  Align(
                    alignment: Alignment(
                      (1 - (gameMap.ratingSteps.$3 / completionsSeconds))
                          .normalize(max: 1, min: 0, newMax: 1, newMin: -1),
                      0,
                    ),
                    child: star,
                  ),
                ],
              ),
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

class _PaperBackground extends StatelessWidget {
  const _PaperBackground({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.paperBackgroundRectThin.provider(),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}
