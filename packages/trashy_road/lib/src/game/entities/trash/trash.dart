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
  glass._('glass'),
  organic._('organic'),
  paper._('paper');

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
class Trash extends PositionedEntity
    with HasGameReference<TrashyRoadGame>, ZIndex {
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
            DroppingBehavior(
              drop: Vector2(0, -45),
              minDuration: 0.1,
            ),
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: GameSettings.gridDimensions,
                position: Vector2(0, GameSettings.gridDimensions.y),
              ),
            ),
          ],
        ) {
    zIndex = position.y.floor();
  }

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

  Trash._appleCore({
    required Vector2 position,
    required AppleCoreStyle style,
  }) : this._(
          position: position,
          trashType: TrashType.organic,
          children: [_AppleCoreSpriteGroup._fromStyle(style)],
        );

  Trash._paper({
    required Vector2 position,
    required PaperStackStyle style,
  }) : this._(
          position: position,
          trashType: TrashType.paper,
          children: [_PaperStackSpriteGroup._fromStyle(style)],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(TiledObject tiledObject) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    final position = Vector2(tiledObject.x, tiledObject.y)..snap();

    switch (type) {
      case TrashType.plastic:
        final style = PlasticBottleStyle._randomize();
        return Trash._plasticBottle(position: position, style: style);
      case TrashType.glass:
        return Trash._glassBottle(position: position);
      case TrashType.organic:
        final style = AppleCoreStyle._randomize();
        return Trash._appleCore(position: position, style: style);
      case TrashType.paper:
        final style = PaperStackStyle._randomize();
        return Trash._paper(position: position, style: style);
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
  /// A crushed plastic bottle that is laying on the ground with its lid facing
  /// east.
  /// {@endtemplate}
  one,

  /// {@template _PlasticBottleStyle.two}
  /// A crushed plastic bottle that is laying on the ground with its lid facing
  /// south-east.
  /// {@endtemplate}
  two;

  factory PlasticBottleStyle._randomize({
    @visibleForTesting Random? random,
  }) {
    return PlasticBottleStyle
        .values[(random ?? _random).nextInt(PlasticBottleStyle.values.length)];
  }

  static final _random = Random();
}

/// The different styles of apple cores.
enum AppleCoreStyle {
  /// {@template _AppleCoreStyle.one}
  /// Two apple cores in a group, one is laying on the ground and the other is
  /// laying on top of the first one.
  /// {@endtemplate}
  one,

  /// {@template _AppleCoreStyle.two}
  /// A single apple core laying on the ground.
  /// {@endtemplate}
  two;

  factory AppleCoreStyle._randomize({
    @visibleForTesting Random? random,
  }) {
    return AppleCoreStyle
        .values[(random ?? _random).nextInt(AppleCoreStyle.values.length)];
  }

  static final _random = Random();
}

/// The different styles of paper.
enum PaperStackStyle {
  /// {@template _PaperStyle.one}
  /// Paper in a neat pile.
  /// {@endtemplate}
  one,

  /// {@template _PaperStyle.two}
  /// Paper scattered around.
  /// {@endtemplate}
  two;

  factory PaperStackStyle._randomize({
    @visibleForTesting Random? random,
  }) {
    return PaperStackStyle
        .values[(random ?? _random).nextInt(PaperStackStyle.values.length)];
  }

  static final _random = Random();
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
          scale: Vector2.all(0.8),
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

  /// {@macro _PlasticBottleStyle.one}
  factory _PlasticBottleSpriteGroup._styleOne() => _PlasticBottleSpriteGroup._(
        spritePath: Assets.images.plasticBottle1.path,
        shadowPath: Assets.images.plasticBottle1Shadow.path,
      );

  /// {@macro _PlasticBottleStyle.two}
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

/// An apple core.
///
/// Renders an apple core and its shadow.
class _AppleCoreSpriteGroup extends PositionComponent
    with HasGameRef<TrashyRoadGame> {
  _AppleCoreSpriteGroup._({
    required String spritePath,
    required String shadowPath,
  }) : super(
          // The `position` and `scale` have been eyeballed to match with the
          // appearance of the map.
          position: Vector2(0.6, 1.4)..toGameSize(),
          scale: Vector2.all(0.5),
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

  /// Derives an [_AppleCoreSpriteGroup] from an [AppleCoreStyle].
  factory _AppleCoreSpriteGroup._fromStyle(
    AppleCoreStyle style,
  ) {
    switch (style) {
      case AppleCoreStyle.one:
        return _AppleCoreSpriteGroup._styleOne();
      case AppleCoreStyle.two:
        return _AppleCoreSpriteGroup._styleTwo();
    }
  }

  /// {@macro _AppleCoreStyle.one}
  factory _AppleCoreSpriteGroup._styleOne() => _AppleCoreSpriteGroup._(
        spritePath: Assets.images.appleCore1.path,
        shadowPath: Assets.images.appleCore1Shadow.path,
      );

  /// {@macro _AppleCoreStyle.two}
  factory _AppleCoreSpriteGroup._styleTwo() => _AppleCoreSpriteGroup._(
        spritePath: Assets.images.appleCore2.path,
        shadowPath: Assets.images.appleCore2Shadow.path,
      );
}

/// A stack of paper
///
/// Renders a stack of paper and its shadow.
class _PaperStackSpriteGroup extends PositionComponent
    with HasGameRef<TrashyRoadGame> {
  _PaperStackSpriteGroup._({
    required String spritePath,
    required String shadowPath,
  }) : super(
          // The `position` and `scale` have been eyeballed to match with the
          // appearance of the map.
          position: Vector2(0.6, 1.4)..toGameSize(),
          scale: Vector2.all(0.5),
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

  /// Derives an [_PaperStackSpriteGroup] from an [PaperStackStyle].
  factory _PaperStackSpriteGroup._fromStyle(
    PaperStackStyle style,
  ) {
    switch (style) {
      case PaperStackStyle.one:
        return _PaperStackSpriteGroup._styleOne();
      case PaperStackStyle.two:
        return _PaperStackSpriteGroup._styleTwo();
    }
  }

  /// {@macro _PaperStackStyle.one}
  factory _PaperStackSpriteGroup._styleOne() => _PaperStackSpriteGroup._(
        spritePath: Assets.images.paper1.path,
        shadowPath: Assets.images.paper1Shadow.path,
      );

  /// {@macro _PaperStackStyle.two}
  factory _PaperStackSpriteGroup._styleTwo() => _PaperStackSpriteGroup._(
        spritePath: Assets.images.paper2.path,
        shadowPath: Assets.images.paper2Shadow.path,
      );
}
