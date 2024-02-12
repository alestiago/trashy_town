import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

class PlayerDragMovingBehavior extends Behavior<Player>
    with FlameBlocReader<GameBloc, GameState> {
  bool _hasMoved =
      false; // Add a flag to track if the player has already moved during the current swipe

  final Vector2 _swipeDeltaPosition = Vector2.zero();

  static const _swipeThreshold = 100;

  void onTapDown(TapDownEvent event) {
    parent.findBehavior<PlayerMovementBehavior>().move(Direction.up);
  }

  void onDragStart(DragStartEvent event) {
    _hasMoved = false; // Reset the flag when the player starts a new swipe
    _swipeDeltaPosition.setAll(0);
  }

  void onDragUpdate(DragUpdateEvent event) {
    if (_hasMoved) {
      return;
    }

    _swipeDeltaPosition.add(event.localDelta);

    final playerMovementBehavior =
        parent.findBehavior<PlayerMovementBehavior>();

    if (_swipeDeltaPosition.x > _swipeThreshold) {
      playerMovementBehavior.move(Direction.right);
      _hasMoved = true;
    } else if (_swipeDeltaPosition.x < -_swipeThreshold) {
      playerMovementBehavior.move(Direction.left);
      _hasMoved = true;
    } else if (_swipeDeltaPosition.y > _swipeThreshold) {
      playerMovementBehavior.move(Direction.down);
      _hasMoved = true;
    } else if (_swipeDeltaPosition.y < -_swipeThreshold) {
      playerMovementBehavior.move(Direction.up);
      _hasMoved = true;
    }
  }
}
