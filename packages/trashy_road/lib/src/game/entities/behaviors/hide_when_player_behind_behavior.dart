import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// Hides the parent entity when the player is behind it.
class HidingWhenPlayerBehind extends CollisionBehavior<Player, PositionedEntity>
    with ParentIsA<PositionedEntity> {
  HidingWhenPlayerBehind({
    double targetOpacity = 0.4,
    Duration duration = const Duration(milliseconds: 100),
    super.children,
    super.priority,
    super.key,
  })  : _targetOpacity = targetOpacity,
        _duration = duration;

  final double _targetOpacity;
  final Duration _duration;
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, Player other) {
    super.onCollisionStart(intersectionPoints, other);

    parent.children.whereType<SpriteComponent>().forEach((element) {
      element.add(
        OpacityEffect.to(
          _targetOpacity,
          EffectController(
            duration: _duration.inMilliseconds.toDouble() / 1000,
          ),
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
