import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:trashy_road/gen/gen.dart';

/// An animated star rating.
///
/// It shows three stars and animates the rating to the given value by
/// filling the stars incrementally.
class AnimatedStarRating extends StatefulWidget {
  const AnimatedStarRating({
    required int rating,
    super.key,
  }) : _rating = rating;

  /// The rating to show.
  ///
  /// It expects a value between 0 and 3.
  ///
  /// A value of 0 will show no stars, a value of 1 will show one star, a value
  /// of 2 will show two stars, and a value of 3 will show three stars. Any
  /// value greater than 3 will also show three stars.
  final int _rating;

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating> {
  late final _StarRatingController _controller;
  late final SMINumber _rating;

  void _onRiveInit(Artboard artboard) {
    _controller = _StarRatingController(artboard);
    artboard.addController(_controller);
    _rating = _controller.findInput<double>('rating')! as SMINumber;

    // TODO(alestiago): Increase incrementally every 200ms.
    _rating.value = widget._rating.toDouble();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _rating.value += 1,
      child: Assets.rive.ratingAnimation.rive(
        onInit: _onRiveInit,
      ),
    );
  }
}

/// A [StateMachineController] for the star rating animation.
class _StarRatingController extends StateMachineController {
  _StarRatingController(
    Artboard artboard,
  ) : super(
          artboard.animations.whereType<StateMachine>().firstWhere(
                (stateMachine) => stateMachine.name == _stateMachineName,
              ),
        ) {
    rating = findSMI(_ratingInputName)!;
  }

  /// The name, defined in Rive, of the state machine.
  static const _stateMachineName = 'rating_animation';

  /// The name, defined in Rive, of the rating input.
  static const _ratingInputName = 'rating';

  /// The rating input.
  late final SMINumber rating;
}
