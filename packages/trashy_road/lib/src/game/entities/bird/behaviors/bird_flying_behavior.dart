import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

class BirdFlyingBehavior extends Behavior<Bird>
    with HasGameReference<TrashyRoadGame> {
  /// The speed multiplier for the bird.
  static const birdSpeedMultiplier = 30;

  @override
  void update(double dt) {
    super.update(dt);

    final distanceCovered = birdSpeedMultiplier * dt * parent.speed;

    final direction = parent.isFlyingRight ? 1 : -1;
    parent.position.x += distanceCovered * direction;

    final isWithinBound = game.bounds!.isPointInside(parent.position);

    // has exited the screen
    if (!isWithinBound) {
      parent.position.setAll(0);
      if (parent.isFlyingRight) {
        parent.position.x = 0;
      } else {
        parent.position.x = game.bounds!.bottomRight.x;
      }

      parent.position.y = Bird.random.nextDouble() * game.bounds!.bottomRight.y;
    }
  }
}
