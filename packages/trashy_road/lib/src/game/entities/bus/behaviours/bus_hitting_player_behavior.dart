import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

class BusHittingPlayerBehavior extends CollisionBehavior<Player, Bus> {
  @override
  void onCollision(Set<Vector2> intersectionPoints, Player other) {
    super.onCollision(intersectionPoints, other);

    print('Bus hit player!');
  }
}
