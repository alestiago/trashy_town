import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/src/game/entities/barrel/barrel.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

/// The different layers in the Tiled map.
enum _TiledLayer {
  background._('Background'),
  trashLayer._('TrashLayer'),
  coreItemsLayer._('CoreItemsLayer'),
  obstacles._('Obstacles'),
  roadLayer._('RoadLayer');

  const _TiledLayer._(this.name);

  /// The [name] of the layer in the Tiled map.
  final String name;
}

enum _TiledTiles {
  grass,
  road;

  factory _TiledTiles.fromTiledValue(int tiledValue) {
    switch (tiledValue) {
      case 1:
        return _TiledTiles.grass;
      case 2:
        return _TiledTiles.road;
      default:
        throw ArgumentError.value(
          tiledValue,
          'tiledValue',
          'The value must be 1 or 2.',
        );
    }
  }

  PositionComponent build() {
    switch (this) {
      case _TiledTiles.grass:
        return Grass();
      case _TiledTiles.road:
        return Road();
    }
  }
}

class TrashyRoadWorld extends Component {
  TrashyRoadWorld.create({required this.tiled}) {
    tiled.children.map((child) => child.removeFromParent());
    final renderableTiledMap = tiled.tileMap;

    final backgroundLayer =
        renderableTiledMap.getLayer<TileLayer>(_TiledLayer.background.name)!;
    renderableTiledMap.setLayerVisibility(
      // TODO(alestiago): Investigate why the background layer is not being
      // identified as 1, but as 0 by `setLayerVisibility`.
      backgroundLayer.id! - 1,
      visible: false,
    );
    final tiles = backgroundLayer.tileData!;

    for (var row = 0; row < tiles.length; row++) {
      for (var column = 0; column < tiles[row].length; column++) {
        final tile = tiles[row][column];
        final tiledTile = _TiledTiles.fromTiledValue(tile.tile);

        final position = Vector2(
          column.toDouble() * renderableTiledMap.map.tileWidth,
          row.toDouble() * renderableTiledMap.map.tileHeight,
        );
        final component = tiledTile.build()..position = position;
        tiled.add(component);
      }
    }

    final trashGroup = renderableTiledMap.getLayer<ObjectGroup>(
      _TiledLayer.trashLayer.name,
    );
    for (final tiledObject in trashGroup!.objects) {
      tiled.add(Trash.fromTiledObject(tiledObject));
    }

    for (final object in renderableTiledMap
        .getLayer<ObjectGroup>(_TiledLayer.coreItemsLayer.name)!
        .objects) {
      switch (object.type) {
        // TODO(OlliePugh): rename 'spawn' to 'player' in the Tiled map, and
        // consider having a different layer for it.
        case 'spawn':
          tiled.add(Player.fromTiledObject(object));
        // TODO(OlliePugh): rename 'finish' to 'trash_can' in the Tiled map, and
        // consider having a different layer for it.
        case 'finish':
          tiled.add(TrashCan.fromTiledObject(object));
          finishPosition = Vector2(object.x, object.y);
        default:
      }
    }

    final roadLaneLayer =
        renderableTiledMap.getLayer<ObjectGroup>(_TiledLayer.roadLayer.name);
    if (roadLaneLayer == null) {
      throw ArgumentError.value(
        _TiledLayer.roadLayer.name,
        'layer',
        '''The Tiled map must have a layer named "${_TiledLayer.roadLayer.name}".''',
      );
    }
    final roadLaneObjects = roadLaneLayer.objects;
    for (final object in roadLaneObjects) {
      final roadLane = RoadLane.fromTiledObject(object);
      tiled.add(roadLane);
    }

    final obstaclesLayer =
        renderableTiledMap.getLayer<ObjectGroup>(_TiledLayer.obstacles.name);
    if (obstaclesLayer == null) {
      throw ArgumentError.value(
        _TiledLayer.obstacles.name,
        'layer',
        '''The Tiled map must have a layer named "${_TiledLayer.obstacles.name}".''',
      );
    }
    final obstacles = obstaclesLayer.objects;
    for (final object in obstacles) {
      final obstacle = Barrel.fromTiledObject(object);
      tiled.add(obstacle);
    }

    final bottomRightPosition =
        tiled.topLeftPosition + Vector2(tiled.width, tiled.height);
    bounds = MapBounds(tiled.topLeftPosition, bottomRightPosition);
  }

  final TiledComponent tiled;

  late Vector2 finishPosition;

  late MapBounds bounds;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(tiled);
  }
}
