import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/src/game/game.dart';

/// A border around the map.
///
/// Blocks the [Player] from leaving the map.
class MapEdge extends UntraversableEntity {
  /// Derives a [MapEdge] from a [TiledObject].
  factory MapEdge.fromTiledObject(TiledObject tiledObject) {
    return MapEdge._(
      position: Vector2(tiledObject.x, tiledObject.y),
      size: Vector2(tiledObject.width, tiledObject.height),
    );
  }
  MapEdge._({required super.position, required super.size})
      : super(
          anchor: Anchor.topLeft,
        ) {
    addAll([
      PropagatingCollisionBehavior(
        RectangleHitbox(
          size: size,
        ),
      ),
      RectangleComponent(size: size)
        ..setColor(
          const Color.fromARGB(_opaqueness, 0, 0, 0),
        ),
    ]);
  }

  /// The opaqueness of the border.
  ///
  /// 0 is fully transparent, 255 is fully opaque.
  static const int _opaqueness = 64;
}
