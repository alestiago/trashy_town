import 'dart:async';
import 'dart:math';

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
    required PlasticBottleStyle style,
  }) : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [_PlasticBottleSpriteGroup._fromStyle(style)],
        );

  Trash._glassBottle({
    required Vector2 position,
  }) : this._(
          position: position,
          trashType: TrashType.glass,
          children: [_GlassBottleSprite()],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(
    TiledObject tiledObject, {
    required Random random,
  }) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    final position = Vector2(tiledObject.x, tiledObject.y)..snap();

    switch (type) {
      case TrashType.plastic:
        final style = PlasticBottleStyle._random(random: random);
        return Trash._plasticBottle(position: position, style: style);
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

/// The different styles of plastic bottles.
enum PlasticBottleStyle {
  /// {@template _PlasticBottleStyle.one}
  /// A crashed plastic bottle that is lying on the ground with its lid facing
  /// east.
  /// {@endtemplate}
  one,

  /// {@template _PlasticBottleStyle.two}
  /// A crashed plastic bottle that is lying on the ground with its lid facing
  /// south-east.
  /// {@endtemplate}
  two;

  factory PlasticBottleStyle._random({required Random random}) {
    return PlasticBottleStyle
        .values[random.nextInt(PlasticBottleStyle.values.length)];
  }
}

/// A plastic bottle.
///
/// Renders the plastic bottle and its shadow.
class _PlasticBottleSpriteGroup extends PositionComponent
    with HasGameRef<TrashyRoadGame> {
  _PlasticBottleSpriteGroup._({
    required String spritePath,
    required String shadowPath,
  }) : super(
          // The `position` and `scale` have been eyeballed to match with the
          // appearance of the map.
          position: Vector2(0.5, 1.4)..toGameSize(),
          scale: Vector2.all(1.2),
          anchor: Anchor.center,
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: shadowPath,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: spritePath,
            ),
          ],
        );

  /// Derives a [_PlasticBottleSpriteGroup] from a [PlasticBottleStyle].
  factory _PlasticBottleSpriteGroup._fromStyle(
    PlasticBottleStyle style,
  ) {
    switch (style) {
      case PlasticBottleStyle.one:
        return _PlasticBottleSpriteGroup._styleOne();
      case PlasticBottleStyle.two:
        return _PlasticBottleSpriteGroup._styleTwo();
    }
  }

  /// A crashed plastic bottle that is lying on the ground with its lid facing
  /// east.
  factory _PlasticBottleSpriteGroup._styleOne() => _PlasticBottleSpriteGroup._(
        spritePath: Assets.images.plasticBottle1.path,
        shadowPath: Assets.images.plasticBottle1Shadow.path,
      );

  /// A crashed plastic bottle that is lying on the ground with its lid facing
  /// south-east.
  factory _PlasticBottleSpriteGroup._styleTwo() => _PlasticBottleSpriteGroup._(
        spritePath: Assets.images.plasticBottle2.path,
        shadowPath: Assets.images.plasticBottle2Shadow.path,
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
