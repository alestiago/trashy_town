import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// A behavior that allows the [Player] to move using mobile gestures.
///
/// Forward movement can be achieved through tapping the screen
///
/// Directional movement can be achieved through swiping in the desired
/// direction
///
/// This behavior is meant to be used in conjunction with [PlayerMovingBehavior]
class PlayerDragMovingBehavior extends Behavior<Player> {
  bool _hasMoved = false;

  final Vector2 _swipeDeltaPosition = Vector2.zero();

  static const _swipeThreshold = 100;

  void onTapUp(TapUpEvent event) {
    parent.findBehavior<PlayerMovingBehavior>().move(Direction.up);
  }

  void onDragStart(DragStartEvent event) {
    _hasMoved = false;
    _swipeDeltaPosition.setAll(0);
  }

  void _move(Direction direction) {
    final playerMovingBehavior = parent.findBehavior<PlayerMovingBehavior>();
    _hasMoved = true;
    playerMovingBehavior.move(direction);
  }

  void onDragUpdate(DragUpdateEvent event) {
    if (_hasMoved) {
      return;
    }

    _swipeDeltaPosition.add(event.localDelta);

    if (_swipeDeltaPosition.x > _swipeThreshold) {
      _move(Direction.right);
    } else if (_swipeDeltaPosition.x < -_swipeThreshold) {
      _move(Direction.left);
    } else if (_swipeDeltaPosition.y > _swipeThreshold) {
      _move(Direction.down);
    } else if (_swipeDeltaPosition.y < -_swipeThreshold) {
      _move(Direction.up);
    }
  }
}
