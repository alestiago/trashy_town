import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Communicates to the [PlayerKeyboardMovingBehavior] that the player
/// has collided with an [Untraversable] component.
class PlayerObstacleBehavior extends CollisionBehavior<Untraversable, Player> {
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    Untraversable other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other.untraversable) {
      parent.findBehavior<PlayerMovingBehavior>().bounceBack();
    }
  }
}
