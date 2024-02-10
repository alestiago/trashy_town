import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';

class Obstacle extends PositionedEntity {
  Obstacle({
    required Vector2 super.size,
    super.children,
    super.position,
    super.anchor,
    super.priority,
    Iterable<Behavior>? behaviors,
  }) : super(
          behaviors: [
            if (behaviors != null) ...behaviors,
            PropagatingCollisionBehavior(
              RectangleHitbox(
                anchor: Anchor.topCenter,
                size: Vector2.all(0.8).convertToGameSize(),
                position: Vector2(
                  size.x / 2,
                  size.y - GameSettings.gridDimensions.y,
                ),
              ),
            ),
          ],
        );
}
