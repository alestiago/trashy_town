import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Communicates to the [PlayerKeyboardMovingBehavior] that the player
///  has collided with an [Obstacle].
class PlayerObstacleBehavior extends CollisionBehavior<Obstacle, Player> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, Obstacle other) {
    super.onCollision(intersectionPoints, other);

    parent.findBehavior<PlayerMovingBehavior>().bounceBack();
  }
}
