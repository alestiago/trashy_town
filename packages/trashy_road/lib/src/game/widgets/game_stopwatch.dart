import 'package:basura/basura.dart';
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
    final gameBloc = BlocProvider.of<GameBloc>(context);
    final gameMapsBloc = BlocProvider.of<GameMapsBloc>(context);
    final gameMap = gameMapsBloc.state.maps[gameBloc.state.identifier]!;

    final completionsSeconds = gameMap.completionSeconds;

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
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (_, __) {
                    final seconds = _stopwatch.elapsed.inSeconds;
                    final percentageLeft = 1 - (seconds / completionsSeconds);

                    return DecoratedBox(
                      decoration:
                          const BoxDecoration(color: BasuraColors.black),
                      child: SizedBox(
                        width: constraints.maxWidth * percentageLeft,
                        height: 30,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
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
