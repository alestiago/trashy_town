import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Communicates to the [PlayerKeyboardMovingBehavior] that the player
/// has collided with an [Obstacle].
class PlayerObstacleBehavior
    extends CollisionBehavior<UntraversableEntity, Player> {
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    UntraversableEntity other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    parent.findBehavior<PlayerMovingBehavior>().bounceBack();
  }
}
