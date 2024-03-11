import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/src/game/game.dart';

/// The different layers in the Tiled map.
enum _TiledLayer {
  trashLayer._('TrashLayer'),
  coreItemsLayer._('CoreItemsLayer'),
  obstacles._('Obstacles'),
  roadLayer._('RoadLayer'),
  borderLayer._('Border');

  const _TiledLayer._(this.name);

  /// The [name] of the layer in the Tiled map.
  final String name;
}

class TrashyRoadWorld extends PositionComponent {
  TrashyRoadWorld({
    required this.tileMap,
  });

  final TiledMap tileMap;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final borderLayer = tileMap.getObjectGroup(_TiledLayer.borderLayer.name);
    await addAll(borderLayer.objects.map(MapEdge.fromTiledObject));

    final trashLayer = tileMap.getObjectGroup(_TiledLayer.trashLayer.name);
    await addAll(trashLayer.objects.map(Trash.fromTiledObject));

    final coreItemsLayer =
        tileMap.getObjectGroup(_TiledLayer.coreItemsLayer.name);

    final playerObjects =
        coreItemsLayer.objects.where((object) => object.type == 'player');

    await addAll(playerObjects.map(Player.fromTiledObject));
    final trashCanObjects =
        coreItemsLayer.objects.where((object) => object.type == 'trash_can');
    await addAll(trashCanObjects.map(TrashCan.fromTiledObject));

    final roadLaneLayer = tileMap.getObjectGroup(_TiledLayer.roadLayer.name);
    await addAll(roadLaneLayer.objects.map(RoadLane.fromTiledObject));

    final obstaclesLayer = tileMap.getObjectGroup(_TiledLayer.obstacles.name);
    await addAll(obstaclesLayer.objects.map(Obstacle.fromTiledObject));

    size = Vector2(tileMap.width.toDouble(), tileMap.height.toDouble());
  }
}

extension on TiledMap {
  ObjectGroup getObjectGroup(String name) {
    final objectGroup = layerByName(name) as ObjectGroup?;
    if (objectGroup == null) {
      throw ArgumentError.value(
        name,
        'layer',
        '''The Tiled map must have a layer named "$name".''',
      );
    }
    return objectGroup;
  }
}
