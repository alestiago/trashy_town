import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/src/game/entities/barrel/barrel.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

/// The different layers in the Tiled map.
enum _TiledLayer {
  trashLayer._('TrashLayer'),
  coreItemsLayer._('CoreItemsLayer'),
  obstacles._('Obstacles'),
  roadLayer._('RoadLayer');

  const _TiledLayer._(this.name);

  /// The [name] of the layer in the Tiled map.
  final String name;
}

class TrashyRoadWorld extends Component {
  TrashyRoadWorld.create({required this.tiled}) {
    final trashGroup = tiled.tileMap.getLayer<ObjectGroup>(
      _TiledLayer.trashLayer.name,
    );
    for (final tiledObject in trashGroup!.objects) {
      tiled.add(Trash.fromTiledObject(tiledObject));
    }

    for (final object in tiled.tileMap
        .getLayer<ObjectGroup>(_TiledLayer.coreItemsLayer.name)!
        .objects) {
      switch (object.type) {
        case 'player':
          tiled.add(Player.fromTiledObject(object));
        case 'trash_can':
          tiled.add(TrashCan.fromTiledObject(object));
          finishPosition = Vector2(object.x, object.y);
        default:
      }
    }

    final roadLaneLayer =
        tiled.tileMap.getLayer<ObjectGroup>(_TiledLayer.roadLayer.name);
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
        tiled.tileMap.getLayer<ObjectGroup>(_TiledLayer.obstacles.name);
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
