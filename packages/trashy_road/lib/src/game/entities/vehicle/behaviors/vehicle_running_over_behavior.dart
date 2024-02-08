import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Allows a [Vehicle] to run over a [Player].
///
/// When the player is hit by the vehicle, it will lose the game.
class VehicleRunningOverBehavior extends CollisionBehavior<Player, Vehicle> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, Player other) {
    super.onCollision(intersectionPoints, other);

    // TODO(alestiago): Implement game resetting.
    // ignore: avoid_print
    print('Vehicle hit player!');
  }
}
