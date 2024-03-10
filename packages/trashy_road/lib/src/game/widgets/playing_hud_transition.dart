import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayingHudTransition extends StatefulWidget {
  const PlayingHudTransition({
    required this.child,
    required this.slideTween,
    super.key,
  });

  /// The time the transition should take.
  static const animationDuration = Duration(seconds: 1);

  final Widget child;

  final Tween<Offset> slideTween;

  @override
  State<PlayingHudTransition> createState() => _PlayingHudTransitionState();
}

class _PlayingHudTransitionState extends State<PlayingHudTransition>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: PlayingHudTransition.animationDuration,
    vsync: this,
  );

  late final _slideAnimation = widget.slideTween.animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gameBloc = context.read<GameBloc>();
    if (gameBloc.state.status.canPlay) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) => current.status.canPlay,
          listener: (context, state) {
            _controller.forward();
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) => !current.status.canPlay,
          listener: (context, state) {
            _controller.reverse();
          },
        ),
      ],
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

extension on GameStatus {
  /// Whether the game is ready to be played.
  ///
  /// If so, the HUD should be visible.
  bool get canPlay => this == GameStatus.playing || this == GameStatus.ready;
}
