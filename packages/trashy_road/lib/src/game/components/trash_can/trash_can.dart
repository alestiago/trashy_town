import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCan extends TileBoundSpriteComponent
    with FlameBlocReader<GameBloc, GameState>, HasGameRef<TrashyRoadGame> {
  TrashCan._({super.position});

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    return TrashCan._(
      position: Vector2(tiledObject.x, tiledObject.y),
    );
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      Assets.images.trashCan.path,
      images: game.images,
    );

    add(RectangleHitbox());
    return super.onLoad();
  }
}
