import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Communicates to the [PlayerKeyboardMovingBehavior] that the player
/// has collided with an [Obstacle].
class PlayerObstacleBehavior<T extends PositionedEntity>
    extends CollisionBehavior<T, Player> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, T other) {
    super.onCollisionStart(intersectionPoints, other);
    parent.findBehavior<PlayerMovingBehavior>().bounceBack();
  }
}
