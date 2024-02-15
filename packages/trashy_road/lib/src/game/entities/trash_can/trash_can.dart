import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
abstract class TrashCan extends Obstacle {
  TrashCan({
    required Vector2 position,
    required SpriteComponent sprite,
    required this.trashType,
  }) : super(
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          behaviors: [
            TrashCanFocusingBehavior(),
          ],
          children: [
            _TrashCanShadowSpriteComponent(),
            sprite,
          ],
        );

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

  @override
  FutureOr<void> onLoad() {
    add(TrashCanDepositingBehavior());

    return super.onLoad();
  }
}

class _TrashCanShadowSpriteComponent extends SpriteComponent
    with ParentIsA<TrashCan>, HasGameReference {
  _TrashCanShadowSpriteComponent()
      : super(position: Vector2(0.27, 0.5)..toGameSize());

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    priority = 0;
    sprite = await Sprite.load(
      Assets.images.trashCanShadow.path,
      images: game.images,
    );
  }
}
