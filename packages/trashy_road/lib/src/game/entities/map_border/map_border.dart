import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';

import 'package:trashy_road/src/game/game.dart';

class MapBorder extends Obstacle {
  MapBorder._({required super.position, required super.size})
      : super(
          blockOnlyBottomTile: false,
          anchor: Anchor.topLeft,
          children: [
            RectangleComponent(size: Vector2.copy(size)..toGameSize())
              ..setColor(
                const Color.fromARGB(64, 0, 0, 0),
              ),
          ],
        );

  /// Derives a [MapBorder] from a [TiledObject].
  factory MapBorder.fromTiledObject(TiledObject tiledObject) {
    return MapBorder._(
      position: Vector2(tiledObject.x, tiledObject.y),
      size: Vector2(tiledObject.width, tiledObject.height)
        ..divide(GameSettings.gridDimensions),
    );
  }
}
