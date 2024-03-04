import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:trashy_road/gen/gen.dart';

/// An animated star.
class AnimatedStar extends StatefulWidget {
  const AnimatedStar({
    super.key,
    this.faded = false,
  });

  final bool faded;

  @override
  State<AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar>
    with SingleTickerProviderStateMixin {
  _StarController? _controller;

  void _onRiveInit(Artboard artboard) {
    _controller = _StarController(artboard);
    artboard.addController(_controller!);
  }

  @override
  void didUpdateWidget(covariant AnimatedStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null) _controller!.faded.value = widget.faded;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Assets.rive.starAnimation.rive(onInit: _onRiveInit);
  }
}

/// A [StateMachineController] for the [AnimatedStar].
class _StarController extends StateMachineController {
  _StarController(Artboard artboard)
      : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == _stateMachineName,
              ),
        ) {
    faded = findSMI(_fadeInputName)!;
  }

  /// The name, defined in Rive, of the state machine.
  static const _stateMachineName = 'dying_star';

  /// The name, defined in Rive, of the rating input.
  static const _fadeInputName = 'fade';

  /// The rating input.
  late final SMIBool faded;
}
