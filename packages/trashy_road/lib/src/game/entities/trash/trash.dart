import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
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
class Trash extends PositionedEntity with HasGameReference<TrashyRoadGame> {
  Trash._({
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

  Trash._plasticBottle({
    required Vector2 position,
  }) : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [_PlasticBottleSpriteGroup()],
        );

  Trash._glassBottle({
    required Vector2 position,
  }) : this._(
          position: position,
          trashType: TrashType.glass,
          children: [_GlassBottleSprite()],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(TiledObject tiledObject) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    final position = Vector2(tiledObject.x, tiledObject.y)..snap();

    switch (type) {
      case TrashType.plastic:
        return Trash._plasticBottle(position: position);
      case TrashType.glass:
        return Trash._glassBottle(position: position);
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
    // TODO(alestiago): Play a sound according to what type of trash it is.
    game.effectPlayer.play(AssetSource(Assets.audio.plasticBottle));

    // TODO(alestiago): Consider whether or not to add the scale effect to the
    // trash again.

    findBehavior<PropagatingCollisionBehavior>()
        .children
        .whereType<RectangleHitbox>()
        .first
        .collisionType = CollisionType.inactive;
    super.removeFromParent();
  }

  final TrashType trashType;
}

/// A plastic bottle.
///
/// Renders the plastic bottle and its shadow.
class _PlasticBottleSpriteGroup extends PositionComponent {
  _PlasticBottleSpriteGroup()
      : super(
          // The `position` and `scale` have been eyeballed to match with the
          // appearance of the map.
          position: Vector2(0.5, 1.2)..toGameSize(),
          scale: Vector2.all(1.2),
          anchor: Anchor.center,
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: Assets.images.plasticBottleShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: Assets.images.plasticBottle.path,
            ),
          ],
        );
}

class _GlassBottleSprite extends SpriteComponent with HasGameReference {
  // TODO(OlliePugh): Make it a SpriteGroup with the actual 3D renders of the
  // glass bottle and its shadow.
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      ColorEffect(
        Colors.green,
        EffectController(
          duration: 0,
        ),
        opacityTo: 0.5,
      ),
    );
    sprite = await Sprite.load(Assets.images.trash.path, images: game.images);
  }
}
