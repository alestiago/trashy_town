import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class Trash extends TileBoundSpriteComponent with HasGameReference {
  Trash._({super.position});

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(TiledObject tiledObject) {
    return Trash._(
      position: Vector2(tiledObject.x, tiledObject.y),
    );
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      Assets.images.trash.path,
      images: game.images,
    );

    add(
      RectangleHitbox(
        size: GameSettings.gridDimensions,
        position: Vector2(0, GameSettings.gridDimensions.y),
      ),
    );
    return super.onLoad();
  }
}
