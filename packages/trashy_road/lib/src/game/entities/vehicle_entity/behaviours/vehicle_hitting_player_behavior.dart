import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Behavior for when a [VehicleEntity] hits a [Player]
class VehicleHittingPlayerBehavior
    extends CollisionBehavior<Player, VehicleEntity> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, Player other) {
    super.onCollision(intersectionPoints, other);

    print('Vehicle hit player!');
  }
}
