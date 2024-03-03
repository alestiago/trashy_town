import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Hides the parent entity when the player is behind it.
class HidingWhenPlayerBehind extends CollisionBehavior<Player, PositionedEntity>
    with ParentIsA<PositionedEntity> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, Player other) {
    super.onCollisionStart(intersectionPoints, other);

    parent.children.whereType<SpriteComponent>().forEach((element) {
      element.add(
        OpacityEffect.to(
          0.4,
          EffectController(duration: 0.1),
        ),
      );
    });
  }

  @override
  void onCollisionEnd(Player other) {
    super.onCollisionEnd(other);

    parent.children.whereType<SpriteComponent>().forEach((element) {
      element.add(
        OpacityEffect.to(
          1,
          EffectController(duration: 0.1),
        ),
      );
    });
  }
}
