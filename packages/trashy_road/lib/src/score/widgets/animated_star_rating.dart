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

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with SingleTickerProviderStateMixin {
  late final _StarRatingController _controller;

  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget._rating),
  );

  late final _animation = Tween<double>(
    begin: 0,
    end: widget._rating.toDouble(),
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ),
  );

  void _onRiveInit(Artboard artboard) {
    _controller = _StarRatingController(artboard);
    artboard.addController(_controller);

    _animation.addListener(_onAnimationChanged);
    _animationController.forward(from: 0);
  }

  void _onAnimationChanged() {
    final currentStars = _controller.rating.value;
    if (currentStars >= widget._rating) return;

    final currentProgress = _animation.value;
    final nextStars = currentStars + 1;
    if (currentProgress >= nextStars) {
      _controller.rating.value = nextStars;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedStarRating oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.rating.value = 0;
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Assets.rive.ratingAnimation.rive(onInit: _onRiveInit);
  }
}

/// A [StateMachineController] for the star rating animation.
class _StarRatingController extends StateMachineController {
  _StarRatingController(Artboard artboard)
      : super(
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
