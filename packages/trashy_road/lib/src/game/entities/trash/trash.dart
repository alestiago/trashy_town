import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

/// The different types of [Trash].
enum TrashType {
  plastic._('plastic'),
  glass._('glass');

  const TrashType._(this.name);

  /// The [name] of the trash type in the Tiled map.
  final String name;

  @internal
  static TrashType? tryParse(String value) => _valueToEnumMap[value];

  static final _valueToEnumMap = <String, TrashType>{
    for (final value in TrashType.values) value.name: value,
  };
}

/// A piece of trash.
///
/// Trash is usually scattered around the road and the player has to pick it up
/// to keep the map clean.
abstract class Trash extends PositionedEntity {
  Trash({
    required Vector2 position,
    required this.trashType,
    super.children,
  }) : super(
          anchor: Anchor.bottomLeft,
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          priority: position.y.floor(),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: GameSettings.gridDimensions,
                position: Vector2(0, GameSettings.gridDimensions.y),
              ),
            ),
          ],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(TiledObject tiledObject) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    switch (type) {
      case TrashType.plastic:
        return TrashPlastic.fromTiledObject(tiledObject);
      case TrashType.glass:
        return TrashGlass.fromTiledObject(tiledObject);
      case null:
        throw ArgumentError.value(
          type,
          'tiledObject.properties["type"]',
          'Invalid trash type',
        );
    }
  }

  @override
  void removeFromParent() {
    findBehavior<PropagatingCollisionBehavior>()
        .children
        .whereType<RectangleHitbox>()
        .first
        .collisionType = CollisionType.inactive;

    final animator = children.whereType<TrashCollectionAnimator>().firstOrNull;
    if (animator != null) {
      animator.add(
        ScaleEffect.to(
          Vector2.zero(),
          EffectController(
            duration: 0.4,
            curve: Curves.easeInBack,
          ),
          onComplete: super.removeFromParent,
        ),
      );
    } else {
      super.removeFromParent();
    }
  }

  final TrashType trashType;
}

class TrashCollectionAnimator extends PositionComponent {
  TrashCollectionAnimator({super.position, super.scale, super.children})
      : super(
          anchor: Anchor.center,
        );
}
