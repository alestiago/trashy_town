import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

class BirdRandomSpawningBehavior extends Behavior<Bird>
    with HasGameReference<TrashyRoadGame> {
  @override
  void onLoad() {
    if (!parent.isFlyingRight) {
      parent.flipHorizontally();
    }

    final x = Bird.random.nextDouble() * game.bounds!.bottomRight.x;
    final y = Bird.random.nextDouble() * game.bounds!.bottomRight.y;
    parent.position = Vector2(x, y);
  }
}
