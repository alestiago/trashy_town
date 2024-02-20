import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
abstract class TrashCan extends PositionedEntity with Untraversable {
  TrashCan({
    required Vector2 position,
    required this.trashType,
    Iterable<Component>? children,
  }) : super(
          anchor: Anchor.bottomLeft,
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          behaviors: [
            TrashCanFocusingBehavior(),
            TrashCanDepositingBehavior(),
          ],
          children: [
            _TrashCanShadowSpriteComponent(),
            ...?children,
          ],
        ) {
    add(
      PropagatingCollisionBehavior(
        RectangleHitbox(
          anchor: Anchor.topCenter,
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(size.x / 2, size.y - GameSettings.gridDimensions.y),
        ),
      ),
    );
  }

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    switch (type) {
      case TrashType.plastic:
        return TrashCanGlass.fromTiledObject(tiledObject);
      case TrashType.glass:
        return TrashCanPlastic.fromTiledObject(tiledObject);
      case null:
        throw Exception('Invalid trash type: ${tiledObject.properties}');
    }
  }

  /// Whether the trash can is focused.
  bool focused = false;

  /// The type of trash that the trash can accepts.
  final TrashType trashType;
}

class _TrashCanShadowSpriteComponent extends SpriteComponent
    with ParentIsA<TrashCan>, HasGameReference {
  _TrashCanShadowSpriteComponent()
      : super(position: Vector2(0.27, 0.5)..toGameSize()) {
    priority = 0;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.trashCanShadow.path,
      images: game.images,
    );
  }
}
